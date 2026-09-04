(* Label component. *)

let createElement ?(for_ : string option) ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-label"; class_ ] in
  let attrs = ("class", `String class_str) :: attrs in
  let attrs =
    match for_ with Some f -> ("for", `String f) :: attrs | None -> attrs
  in
  JSX.node "label" attrs [ children ]

let make = createElement
