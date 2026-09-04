(* Breadcrumb navigation — [nav] with [aria-label], ordered list, and
    [aria-current="page"] on the current item. The separator between items
    is hidden on the last item via CSS. *)

let createElement ?(class_ = "") ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-breadcrumb"; class_ ] in
  JSX.node "nav"
    (("class", `String class_str)
    :: ("aria-label", `String "Breadcrumb")
    :: attrs)
    [
      JSX.node "ol"
        [ ("class", `String "ocelot-breadcrumb__list") ]
        [ children ];
    ]

module Item = struct
  let createElement ?(is_current = false) ?href
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    let link_attrs = [ ("class", `String "ocelot-breadcrumb__link") ] in
    let link_attrs =
      match href with
      | Some h -> ("href", `String h) :: link_attrs
      | None -> link_attrs
    in
    let link =
      if is_current then
        JSX.node "span"
          [
            ("class", `String "ocelot-breadcrumb__current");
            ("aria-current", `String "page");
          ]
          [ children ]
      else JSX.node "a" (link_attrs @ attrs) [ children ]
    in
    let sep =
      JSX.node "span"
        [
          ("class", `String "ocelot-breadcrumb__separator");
          ("aria-hidden", `String "true");
        ]
        [ JSX.string "/" ]
    in
    JSX.node "li" [ ("class", `String "ocelot-breadcrumb__item") ] [ link; sep ]

  let make = createElement
end

let make = createElement
