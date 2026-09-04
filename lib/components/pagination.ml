(* Pagination — [nav] with [aria-label], list of page links with
    [aria-current="page"] on the active page and [aria-disabled] on
    disabled controls. *)

module Item = struct
  let[@ocelot.htmx] createElement ?(is_current = false) ?(is_disabled = false)
      ?href ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    let link_attrs = ref [ ("class", `String "ocelot-pagination__link") ] in
    if is_current then
      link_attrs := ("aria-current", `String "page") :: !link_attrs;
    if is_disabled then
      link_attrs := ("aria-disabled", `String "true") :: !link_attrs;
    Option.iter (fun h -> link_attrs := ("href", `String h) :: !link_attrs) href;
    let link = JSX.node "a" (List.rev !link_attrs @ attrs) [ children ] in
    JSX.node "li" [ ("class", `String "ocelot-pagination__item") ] [ link ]

  let make = createElement
end

module Ellipsis = struct
  let[@ocelot.htmx] createElement ?(class_ = "")
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    ignore children;
    JSX.node "li"
      (( "class",
         `String (Html_util.class_value [ "ocelot-pagination__item"; class_ ])
       )
      :: attrs)
      [
        JSX.node "span"
          [ ("class", `String "ocelot-pagination__ellipsis") ]
          [ JSX.string "…" ];
      ]

  let make = createElement
end

let[@ocelot.htmx] createElement ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-pagination"; class_ ] in
  JSX.node "nav"
    (("class", `String class_str)
    :: ("aria-label", `String "Pagination")
    :: attrs)
    [
      JSX.node "ul"
        [ ("class", `String "ocelot-pagination__list") ]
        [ children ];
    ]

let make = createElement
