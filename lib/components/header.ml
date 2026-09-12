(* Header — the top bar of the app shell, completing [Sidebar].

   Renders a sticky [<header>] with three regions:

   - start: an optional brand link and, when [sidebar_id] is given, the
     sidebar drawer trigger (a hamburger button);
   - center: an optional horizontal [nav] with a list of links
     (current and disabled states render [aria-current] /
     [aria-disabled]);
   - end: extra content ([children], e.g. a search input) followed by
     an [actions] slot (e.g. buttons or a [Dropdown] user menu).

   Pure server-rendered markup — no Alpine state of its own. The only
   Alpine references appear on the optional drawer trigger, which flips
   the [drawer] flag owned by the surrounding [Sidebar] layout (render
   the Header inside the Sidebar's children so the x-data scope
   cascades, and pass the Sidebar's [id] as [sidebar_id]):

     <Sidebar id="app-sidebar" mobile_bar=false ...>
       <Header sidebar_id="app-sidebar" brand=... actions=...>
         ...page content...
       </Header>
     </Sidebar>

   Pass [mobile_bar:false] to the Sidebar in that setup so the drawer
   trigger lives in the Header instead of the Sidebar's own mobile bar.
   With no [sidebar_id], the Header works standalone (e.g. above plain
   page content) and renders no trigger.

   The bar is sticky by default ([sticky:false] opts out, e.g. when the
   host application manages its own scrolling container). On small
   screens the nav list scrolls horizontally and the drawer trigger
   becomes visible; everything remains usable with JavaScript disabled
   (only the trigger needs Alpine, which degrades like Modal/Toast). *)

type item = {
  href : string;
  label : string;
  is_current : bool;  (** renders [aria-current="page"] *)
  disabled : bool;
}

let item_link (it : item) =
  let base =
    [ ("class", `String "ocelot-header__link"); ("href", `String it.href) ]
  in
  let attrs =
    if it.is_current then ("aria-current", `String "page") :: base else base
  in
  let attrs =
    if it.disabled then ("aria-disabled", `String "true") :: attrs else attrs
  in
  JSX.node "a" attrs [ JSX.string it.label ]

let item_node (it : item) =
  JSX.node "li" [ ("class", `String "ocelot-header__item") ] [ item_link it ]

let[@ocelot.htmx] createElement ?(brand : JSX.element option)
    ?(brand_href = "/") ?(items : item list = []) ?(aria_label = "Main")
    ?(actions : JSX.element option) ?(sidebar_id : string option)
    ?(sticky = true) ?(id : string option) ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
  (* Drawer trigger: only when a Sidebar hosts the state. Visible on
     small screens only (CSS); it opens the sidebar's off-canvas drawer. *)
  let trigger =
    match sidebar_id with
    | Some sid ->
        [
          JSX.node "button"
            [
              ("class", `String "ocelot-header__menu-btn");
              ("type", `String "button");
              ("aria-label", `String "Open navigation");
              ("aria-controls", `String sid);
              ("aria-expanded", `String "false");
              (":aria-expanded", `String "drawer ? 'true' : 'false'");
              ("@click", `String "drawer = true");
            ]
            [
              JSX.node "span"
                [ ("aria-hidden", `String "true") ]
                [ JSX.string "☰" ];
            ];
        ]
    | None -> []
  in

  let brand_el =
    match brand with
    | Some b ->
        [
          JSX.node "a"
            [
              ("class", `String "ocelot-header__brand");
              ("href", `String brand_href);
            ]
            [ b ];
        ]
    | None -> []
  in

  let start_el =
    let children_ = trigger @ brand_el in
    if children_ = [] then []
    else
      [ JSX.node "div" [ ("class", `String "ocelot-header__start") ] children_ ]
  in

  (* Horizontal navigation; omitted entirely when there are no items. *)
  let nav_el =
    if items = [] then []
    else
      [
        JSX.node "nav"
          [
            ("class", `String "ocelot-header__nav");
            ("aria-label", `String aria_label);
          ]
          [
            JSX.node "ul"
              [ ("class", `String "ocelot-header__list") ]
              (List.map item_node items);
          ];
      ]
  in

  (* End region: extra content (e.g. search) then the actions slot. *)
  let end_children =
    (if Html_util.is_null_element children then [] else [ children ])
    @ match actions with Some a -> [ a ] | None -> []
  in
  let end_el =
    if end_children = [] then []
    else
      [
        JSX.node "div" [ ("class", `String "ocelot-header__end") ] end_children;
      ]
  in

  let header_attrs =
    ( "class",
      `String
        (Html_util.class_value
           [
             "ocelot-header";
             (if sticky then "ocelot-header--sticky" else "");
             class_;
           ]) )
    :: (match id with Some i -> [ ("id", `String i) ] | None -> [])
    @ attrs
  in
  JSX.node "header" header_attrs (start_el @ nav_el @ end_el)

let make = createElement
