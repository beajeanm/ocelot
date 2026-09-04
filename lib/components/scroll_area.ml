(* Scroll Area — a container that scrolls overflowing content with
    consistent, themeable scrollbars (thin, rounded, and colored with the
    theme's border tokens). Pure CSS, no JavaScript. *)

type orientation = Vertical | Horizontal | Both

let orientation_classes = function
  | Vertical -> [ "ocelot-scroll-area--vertical" ]
  | Horizontal -> [ "ocelot-scroll-area--horizontal" ]
  | Both -> [ "ocelot-scroll-area--vertical"; "ocelot-scroll-area--horizontal" ]

let[@ocelot.htmx] createElement ?(max_height : string option)
    ?(orientation = Vertical) ?(class_ = "") ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) () =
  let class_str =
    Html_util.class_value
      (("ocelot-scroll-area" :: orientation_classes orientation) @ [ class_ ])
  in
  let root_attrs = ref [ ("class", `String class_str) ] in
  Option.iter
    (fun h ->
      root_attrs :=
        ("style", `String (Printf.sprintf "max-height: %s" h)) :: !root_attrs)
    max_height;
  JSX.node "div" (List.rev !root_attrs @ attrs) [ children ]

let make = createElement
