(* Scroll Area — a container that scrolls overflowing content with
    consistent, themeable scrollbars (thin, rounded, and colored with the
    theme's border tokens). Pure CSS, no JavaScript. *)

type orientation = Vertical | Horizontal | Both

let orientation_classes = function
  | Vertical -> [ "ocelot-scroll-area--vertical" ]
  | Horizontal -> [ "ocelot-scroll-area--horizontal" ]
  | Both -> [ "ocelot-scroll-area--vertical"; "ocelot-scroll-area--horizontal" ]

let createElement ?(max_height : string option) ?(orientation = Vertical)
    ?(class_ = "") ?(children = JSX.null) () =
  let class_str =
    Html_util.class_value
      (("ocelot-scroll-area" :: orientation_classes orientation) @ [ class_ ])
  in
  let attrs = ref [ ("class", `String class_str) ] in
  Option.iter
    (fun h ->
      attrs := ("style", `String (Printf.sprintf "max-height: %s" h)) :: !attrs)
    max_height;
  JSX.node "div" (List.rev !attrs) [ children ]

let make = createElement
