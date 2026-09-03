(* Input component. [children] is accepted (the JSX runtime always passes
    it) but ignored: [input] is a void element. *)

let createElement ?(type_ = "text") ?name ?value ?placeholder
    ?(disabled = false) ?(required = false) ?(readonly = false) ?id
    ?(class_ = "") ?(children = JSX.null) () =
  ignore children;
  let class_str = Html_util.class_value [ "ocelot-input"; class_ ] in
  let attrs = ref [ ("class", `String class_str); ("type", `String type_) ] in
  Option.iter (fun n -> attrs := ("name", `String n) :: !attrs) name;
  Option.iter (fun v -> attrs := ("value", `String v) :: !attrs) value;
  Option.iter
    (fun p -> attrs := ("placeholder", `String p) :: !attrs)
    placeholder;
  if disabled then attrs := ("disabled", `Bool true) :: !attrs;
  if required then attrs := ("required", `Bool true) :: !attrs;
  if readonly then attrs := ("readonly", `Bool true) :: !attrs;
  Option.iter (fun i -> attrs := ("id", `String i) :: !attrs) id;
  JSX.node "input" (List.rev !attrs) []

let make = createElement
