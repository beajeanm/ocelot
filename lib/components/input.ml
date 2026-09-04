(* Input component. [children] is accepted (the JSX runtime always passes
    it) but ignored: [input] is a void element. *)

let[@ocelot.htmx] createElement ?(type_ = "text") ?name ?value ?placeholder
    ?(disabled = false) ?(required = false) ?(readonly = false) ?id
    ?(class_ = "") ?(attrs : JSX.attribute list = []) ?(children = JSX.null) ()
    =
  ignore children;
  let class_str = Html_util.class_value [ "ocelot-input"; class_ ] in
  let attrs =
    ("class", `String class_str) :: ("type", `String type_) :: attrs
  in
  let attrs =
    match name with Some n -> ("name", `String n) :: attrs | None -> attrs
  in
  let attrs =
    match value with Some v -> ("value", `String v) :: attrs | None -> attrs
  in
  let attrs =
    match placeholder with
    | Some p -> ("placeholder", `String p) :: attrs
    | None -> attrs
  in
  let attrs = if disabled then ("disabled", `Bool true) :: attrs else attrs in
  let attrs = if required then ("required", `Bool true) :: attrs else attrs in
  let attrs = if readonly then ("readonly", `Bool true) :: attrs else attrs in
  let attrs =
    match id with Some i -> ("id", `String i) :: attrs | None -> attrs
  in
  JSX.node "input" attrs []

let make = createElement
