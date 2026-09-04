(* Textarea component. *)

let createElement ?name ?(rows = 4) ?placeholder ?(disabled = false)
    ?(required = false) ?(readonly = false) ?id ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-textarea"; class_ ] in
  let attrs = ("class", `String class_str) :: ("rows", `Int rows) :: attrs in
  let attrs =
    match name with Some n -> ("name", `String n) :: attrs | None -> attrs
  in
  let attrs =
    Option.fold ~none:attrs
      ~some:(fun p -> ("placeholder", `String p) :: attrs)
      placeholder
  in
  let attrs = if disabled then ("disabled", `Bool true) :: attrs else attrs in
  let attrs = if required then ("required", `Bool true) :: attrs else attrs in
  let attrs = if readonly then ("readonly", `Bool true) :: attrs else attrs in
  let attrs =
    Option.fold ~some:(fun i -> ("id", `String i) :: attrs) id ~none:attrs
  in
  JSX.node "textarea" attrs [ children ]

let make = createElement
