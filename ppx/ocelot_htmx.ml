(* ocelot_htmx — internal PPX giving Ocelot components first-class htmx
   props.

   Annotate a component's [createElement] with [\[@ocelot.htmx\]]:

     let createElement [@ocelot.htmx] ?(variant = Primary) ?(class_ = "")
         ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
       ...

   and it gains one optional [string] parameter per row of the [htmx_attrs]
   table below. Each provided prop becomes the matching HTML attribute and
   is merged into the component's [?attrs] list before the original body
   runs, so it flows to the root element like any other attribute:

     let createElement ?(variant = Primary) ?(class_ = "")
         ?hx_get ?hx_post (* ... one per table row ... *)
         ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
       let attrs =
         List.filter_map
           (fun (o, name) -> Option.map (fun v -> (name, `String v)) o)
           [ (hx_get, "hx-get"); (hx_post, "hx-post"); (* ... *) ]
         @ attrs
       in
       ...

   which lets JSX call sites use htmx props directly:

     <Ocelot.Button hx_get="/data" hx_target="#result"> "Click" </Ocelot.Button>

   The annotated function must take a final unit argument and an [?attrs]
   parameter — both are checked at expansion time, so a mistake is a
   build error, not silently-dropped attributes.

   This PPX is internal to the Ocelot build: the published library exposes
   the expanded, fully-typed [make] functions; library users never need it
   (or even know it exists). Adding a new htmx prop for every component is
   a one-line change to [htmx_attrs]. *)

open Ppxlib

(* Single source of truth: (OCaml prop label, HTML attribute).

   Keep in sync with the [Hx] helpers in [lib/hx.ml] (which remain the
   escape hatch for attributes not listed here, e.g. extension attributes
   like SSE/WebSocket). *)
let htmx_attrs : (string * string) list =
  [
    ("hx_get", "hx-get");
    ("hx_post", "hx-post");
    ("hx_put", "hx-put");
    ("hx_patch", "hx-patch");
    ("hx_delete", "hx-delete");
    ("hx_trigger", "hx-trigger");
    ("hx_target", "hx-target");
    ("hx_swap", "hx-swap");
    ("hx_select", "hx-select");
    ("hx_select_oob", "hx-select-oob");
    ("hx_swap_oob", "hx-swap-oob");
    ("hx_vals", "hx-vals");
    ("hx_include", "hx-include");
    ("hx_indicator", "hx-indicator");
    ("hx_confirm", "hx-confirm");
    ("hx_disable", "hx-disable");
    ("hx_disinherit", "hx-disinherit");
    ("hx_encoding", "hx-encoding");
    ("hx_ext", "hx-ext");
    ("hx_headers", "hx-headers");
    ("hx_history", "hx-history");
    ("hx_params", "hx-params");
    ("hx_sync", "hx-sync");
    ("hx_validate", "hx-validate");
    ("hx_preserve", "hx-preserve");
    ("hx_prompt", "hx-prompt");
    ("hx_push_url", "hx-push-url");
    ("hx_replace_url", "hx-replace-url");
    ("hx_request", "hx-request");
    ("hx_boost", "hx-boost");
    ("hx_on", "hx-on");
  ]

let attribute_name = "ocelot.htmx"

type param = {
  label : arg_label;
  default : expression option;
  pat : pattern;
  loc : Location.t;
}

(* Peel a [fun ... -> body] chain into its parameters and body. *)
let rec peel : param list -> expression -> param list * expression =
 fun acc e ->
  match e.pexp_desc with
  | Pexp_function (params, _, Pfunction_body body) ->
      let params =
        List.map
          (fun (fp : function_param) ->
            match fp.pparam_desc with
            | Pparam_val (label, default, pat) ->
                { label; default; pat; loc = fp.pparam_loc }
            | Pparam_newtype _ ->
                Location.raise_errorf ~loc:fp.pparam_loc
                  "[@%s] does not support polymorphic annotations"
                  attribute_name)
          params
      in
      peel (acc @ params) body
  | _ -> (acc, e)

let rebuild ~loc params body =
  Ast_builder.Default.pexp_function ~loc
    (List.map
       (fun (p : param) ->
         Ast_builder.Default.pparam_val ~loc:p.loc p.label p.default p.pat)
       params)
    None (Pfunction_body body)

let label_name (l : arg_label) : string option =
  match l with Nolabel -> None | Labelled txt | Optional txt -> Some txt

let has_attribute name (attrs : attributes) =
  List.exists (fun a -> a.attr_name.txt = name) attrs

let without_attribute name (attrs : attributes) =
  List.filter (fun a -> a.attr_name.txt <> name) attrs

(* [let attrs = <collected htmx attributes> @ attrs in <body>] *)
let wrap_body ~loc body =
  let open Ast_builder.Default in
  let pairs =
    elist ~loc
      (List.map
         (fun (label, name) ->
           pexp_tuple ~loc [ evar ~loc label; estring ~loc name ])
         htmx_attrs)
  in
  [%expr
    let attrs =
      List.filter_map
        (fun (o, name) -> Option.map (fun v -> (name, `String v)) o)
        [%e pairs]
      @ attrs
    in
    [%e body]]

let expand ~loc (expr : expression) : expression =
  let params, body = peel [] expr in
  if not (List.exists (fun p -> p.label = Nolabel) params) then
    Location.raise_errorf ~loc
      "[@%s] must annotate a function that takes a final unit argument"
      attribute_name;
  if not (List.exists (fun p -> label_name p.label = Some "attrs") params) then
    Location.raise_errorf ~loc
      "[@%s] requires an ?attrs parameter to merge htmx attributes into"
      attribute_name;
  let new_params =
    List.map
      (fun (label, _) ->
        {
          label = Optional label;
          default = None;
          pat = Ast_builder.Default.ppat_var ~loc { loc; txt = label };
          loc;
        })
      htmx_attrs
  in
  let rec split prefix = function
    | [] -> (List.rev prefix, [])
    | ({ label = Nolabel; _ } as p) :: rest -> (List.rev prefix, p :: rest)
    | p :: rest -> split (p :: prefix) rest
  in
  let before, after = split [] params in
  rebuild ~loc (before @ new_params @ after) (wrap_body ~loc body)

let value_binding (vb : value_binding) : value_binding =
  if not (has_attribute attribute_name vb.pvb_attributes) then vb
  else
    let expr = expand ~loc:vb.pvb_loc vb.pvb_expr in
    {
      vb with
      pvb_expr = expr;
      pvb_attributes = without_attribute attribute_name vb.pvb_attributes;
    }

let structure_item (si : structure_item) : structure_item =
  match si.pstr_desc with
  | Pstr_value (rf, vbs) ->
      { si with pstr_desc = Pstr_value (rf, List.map value_binding vbs) }
  | _ -> si

let () =
  Driver.register_transformation "ocelot_htmx"
    ~preprocess_impl:(List.map structure_item)
