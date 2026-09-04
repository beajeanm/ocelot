(* Stack — vertical layout container. *)

type gap = G0 | G1 | G2 | G3 | G4 | G5 | G6 | G8

let gap_to_string = function
  | G0 -> "ocelot-stack--gap-0"
  | G1 -> "ocelot-stack--gap-1"
  | G2 -> "ocelot-stack--gap-2"
  | G3 -> "ocelot-stack--gap-3"
  | G4 -> "ocelot-stack--gap-4"
  | G5 -> "ocelot-stack--gap-5"
  | G6 -> "ocelot-stack--gap-6"
  | G8 -> "ocelot-stack--gap-8"

let createElement ?(gap = G2) ?(class_ = "")
    ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) () =
  let class_str =
    Html_util.class_value [ "ocelot-stack"; gap_to_string gap; class_ ]
  in
  JSX.node "div" (("class", `String class_str) :: attrs) [ children ]

let make = createElement
