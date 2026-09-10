(* Sidebar — a persistent app-shell navigation region driven by Alpine.js.

   Renders a full-height, side-pinned [aside] with an optional pinned
   header (brand area) and footer, and a mandatory scrollable [nav] with
   a vertical list of items. A toggle button in the header collapses the
   sidebar to an icon rail (Alpine [collapsed] state).

   The layout is responsive with no JavaScript required for the basic
   navigation to work:

   - Large screens: expanded sidebar next to the content area, which
     adjusts to the sidebar's width (flex row).
   - Medium screens (≤ 60rem): collapses to an icon rail.
   - Small screens (≤ 40rem): becomes an off-canvas drawer. A hamburger
     button appears in a mobile bar above the content; the drawer opens
     with a backdrop and closes via the backdrop, a close button, or
     [Escape]. Focus is trapped inside while open via
     [x-trap.inert.noscroll], which requires the Alpine focus plugin —
     include [Ocelot.Alpine.script] in the page head.

   Markup is server-rendered in the expanded state, so the navigation is
   usable before Alpine loads (and with JavaScript disabled the drawer
   behavior degrades gracefully, like Modal and Toast). *)

type side = Left | Right

type item = {
  href : string;
  label : string;
  icon : JSX.element option;  (** optional; rails show icons only *)
  is_current : bool;  (** renders [aria-current="page"] *)
  disabled : bool;
}

let side_class = function Left -> "" | Right -> "ocelot-sidebar--right"

let item_link (it : item) =
  let base =
    [
      ("class", `String "ocelot-sidebar__link");
      ("href", `String it.href);
      ("title", `String it.label);
    ]
  in
  let attrs =
    if it.is_current then ("aria-current", `String "page") :: base else base
  in
  let attrs =
    if it.disabled then ("aria-disabled", `String "true") :: attrs else attrs
  in
  let icon =
    match it.icon with
    | Some el ->
        [
          JSX.node "span"
            [
              ("class", `String "ocelot-sidebar__icon");
              ("aria-hidden", `String "true");
            ]
            [ el ];
        ]
    | None -> []
  in
  let label =
    JSX.node "span"
      [ ("class", `String "ocelot-sidebar__label") ]
      [ JSX.string it.label ]
  in
  JSX.node "a" attrs (icon @ [ label ])

let item_node (it : item) =
  JSX.node "li" [ ("class", `String "ocelot-sidebar__item") ] [ item_link it ]

let[@ocelot.htmx] createElement ?(side = Left) ?(aria_label = "Sidebar")
    ?(id : string option) ?(header : JSX.element option)
    ?(footer : JSX.element option) ?(collapsed = false) ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null)
    ~(items : item list) () =
  let sidebar_id =
    Option.value id
      ~default:(Alpine_util.derived_id "ocelot-sidebar-" aria_label)
  in
  let x_data = Printf.sprintf "{ collapsed: %b, drawer: false }" collapsed in

  (* Backdrop: shown only while the small-screen drawer is open. *)
  let backdrop =
    JSX.node "div"
      [
        ("class", `String "ocelot-sidebar__backdrop");
        ("x-show", `String "drawer");
        ("x-cloak", `Bool true);
        ("@click", `String "drawer = false");
        ("aria-hidden", `String "true");
      ]
      []
  in

  (* Header: optional brand content, always pinned, always ends with the
     collapse toggle (and the drawer-only close button). *)
  let toggle =
    JSX.node "button"
      [
        ("class", `String "ocelot-sidebar__toggle");
        ("type", `String "button");
        ( "aria-label",
          `String (if collapsed then "Expand sidebar" else "Collapse sidebar")
        );
        ( ":aria-label",
          `String "collapsed ? 'Expand sidebar' : 'Collapse sidebar'" );
        ("aria-expanded", `String (if collapsed then "false" else "true"));
        (":aria-expanded", `String "collapsed ? 'false' : 'true'");
        ("@click", `String "collapsed = !collapsed");
      ]
      [
        JSX.node "span"
          [
            ("class", `String "ocelot-sidebar__toggle-icon");
            ("aria-hidden", `String "true");
          ]
          [ JSX.string "«" ];
      ]
  in
  let close_btn =
    JSX.node "button"
      [
        ("class", `String "ocelot-sidebar__close");
        ("type", `String "button");
        ("aria-label", `String "Close navigation");
        ("@click", `String "drawer = false");
      ]
      [ JSX.string "✕" ]
  in
  let header_class =
    Html_util.class_value
      [
        "ocelot-sidebar__header";
        (match header with
        | Some _ -> ""
        | None -> "ocelot-sidebar__header--bare");
      ]
  in
  let brand =
    match header with
    | Some h ->
        [ JSX.node "div" [ ("class", `String "ocelot-sidebar__brand") ] [ h ] ]
    | None -> []
  in
  let header_el =
    JSX.node "div"
      [ ("class", `String header_class) ]
      (brand @ [ toggle; close_btn ])
  in

  (* Scrollable navigation region with the mandatory items. *)
  let list =
    JSX.node "ul"
      [ ("class", `String "ocelot-sidebar__list") ]
      (List.map item_node items)
  in
  let nav =
    JSX.node "nav"
      [
        ("class", `String "ocelot-sidebar__nav");
        ("aria-label", `String aria_label);
      ]
      [ list ]
  in

  let footer_el =
    match footer with
    | Some f ->
        [
          JSX.node "footer"
            [ ("class", `String "ocelot-sidebar__footer") ]
            [
              JSX.node "div"
                [ ("class", `String "ocelot-sidebar__footer-content") ]
                [ f ];
            ];
        ]
    | None -> []
  in

  let aside =
    JSX.node "aside"
      [
        ( "class",
          `String (Html_util.class_value [ "ocelot-sidebar"; side_class side ])
        );
        ("id", `String sidebar_id);
        ( ":class",
          `String
            "[collapsed && 'ocelot-sidebar--collapsed', drawer && \
             'ocelot-sidebar--open']" );
        ("@keydown.escape.window", `String "drawer = false");
        ("x-trap.inert.noscroll", `String "drawer");
      ]
      ([ header_el; nav ] @ footer_el)
  in

  (* Mobile bar: only visible on small screens, opens the drawer. *)
  let menu_btn =
    JSX.node "button"
      [
        ("class", `String "ocelot-sidebar__menu-btn");
        ("type", `String "button");
        ("aria-label", `String "Open navigation");
        ("aria-controls", `String sidebar_id);
        ("aria-expanded", `String "false");
        (":aria-expanded", `String "drawer ? 'true' : 'false'");
        ("@click", `String "drawer = true");
      ]
      [ JSX.node "span" [ ("aria-hidden", `String "true") ] [ JSX.string "☰" ] ]
  in
  let mobile_bar =
    JSX.node "div"
      [ ("class", `String "ocelot-sidebar__mobile-bar") ]
      [ menu_btn ]
  in
  let content =
    JSX.node "div"
      [ ("class", `String "ocelot-sidebar__content") ]
      [ mobile_bar; children ]
  in

  let layout_class =
    Html_util.class_value
      [
        "ocelot-sidebar-layout";
        (match side with Left -> "" | Right -> "ocelot-sidebar-layout--right");
        class_;
      ]
  in
  JSX.node "div"
    (("class", `String layout_class) :: ("x-data", `String x_data) :: attrs)
    [ backdrop; aside; content ]

let make = createElement
