(* Badge component. *)

type variant = Primary | Secondary | Success | Warning | Danger | Info

let variant_to_string = function
  | Primary -> "ocelot-badge--primary"
  | Secondary -> "ocelot-badge--secondary"
  | Success -> "ocelot-badge--success"
  | Warning -> "ocelot-badge--warning"
  | Danger -> "ocelot-badge--danger"
  | Info -> "ocelot-badge--info"

let createElement ?(variant = Primary) ?(class_ = "") ?(children = JSX.null) ()
    =
  let class_str =
    Html_util.class_value [ "ocelot-badge"; variant_to_string variant; class_ ]
  in
  JSX.node "span" [ ("class", `String class_str) ] [ children ]

let make = createElement
