(* Native Select component — accessible by default, no JavaScript required.

    For a custom styled dropdown with Alpine.js keyboard navigation, see
    [Dropdown]. *)

type option_item = { value : string; label : string; disabled : bool }

let createElement ?name ?id ?(disabled = false) ?(required = false)
    ?(multiple = false) ?(class_ = "") ?(children = JSX.null) ~options () =
  let class_str = Html_util.class_value [ "ocelot-input"; class_ ] in
  let attrs = ref [ ("class", `String class_str) ] in
  Option.iter (fun n -> attrs := ("name", `String n) :: !attrs) name;
  Option.iter (fun i -> attrs := ("id", `String i) :: !attrs) id;
  if disabled then attrs := ("disabled", `Bool true) :: !attrs;
  if required then attrs := ("required", `Bool true) :: !attrs;
  if multiple then attrs := ("multiple", `Bool true) :: !attrs;
  let option_els =
    List.map
      (fun (opt : option_item) ->
        let opt_attrs = ref [ ("value", `String opt.value) ] in
        if opt.disabled then opt_attrs := ("disabled", `Bool true) :: !opt_attrs;
        JSX.node "option" (List.rev !opt_attrs) [ JSX.string opt.label ])
      options
  in
  ignore children;
  JSX.node "select" (List.rev !attrs) option_els

let make = createElement
