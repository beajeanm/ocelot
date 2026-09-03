(* Divider — horizontal or vertical separator. *)

type orientation = Horizontal | Vertical

let createElement ?(orientation = Horizontal) ?(class_ = "") () =
  let orient_class =
    match orientation with
    | Horizontal -> "ocelot-divider--horizontal"
    | Vertical -> "ocelot-divider--vertical"
  in
  let class_str =
    Html_util.class_value [ "ocelot-divider"; orient_class; class_ ]
  in
  JSX.node "hr" [ ("class", `String class_str) ] []

let make = createElement
