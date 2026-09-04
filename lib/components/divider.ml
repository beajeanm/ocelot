(* Divider — horizontal or vertical separator. *)

type orientation = Horizontal | Vertical

let[@ocelot.htmx] createElement ?(orientation = Horizontal) ?(class_ = "")
    ?(attrs : JSX.attribute list = []) () =
  let orient_class =
    match orientation with
    | Horizontal -> "ocelot-divider--horizontal"
    | Vertical -> "ocelot-divider--vertical"
  in
  let class_str =
    Html_util.class_value [ "ocelot-divider"; orient_class; class_ ]
  in
  JSX.node "hr" (("class", `String class_str) :: attrs) []

let make = createElement
