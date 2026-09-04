(* Alert component. *)

type variant = Success | Warning | Danger | Info

let variant_to_string = function
  | Success -> "ocelot-alert--success"
  | Warning -> "ocelot-alert--warning"
  | Danger -> "ocelot-alert--danger"
  | Info -> "ocelot-alert--info"

let createElement ?(variant = Info) ?(class_ = "") ?(title : string option)
    ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) () =
  let class_str =
    Html_util.class_value [ "ocelot-alert"; variant_to_string variant; class_ ]
  in
  let attrs = ("class", `String class_str) :: ("role", `String "alert") :: attrs in
  match title with
  | Some t ->
      let title_el = JSX.node "strong" [] [ JSX.string t ] in
      let sep = JSX.string ": " in
      JSX.node "div" attrs (title_el :: sep :: [ children ])
  | None -> JSX.node "div" attrs [ children ]

let make = createElement
