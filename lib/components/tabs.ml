(* Tabs — accessible tab interface driven by Alpine.js.

   Renders a [role="tablist"] with buttons and [role="tabpanel"] regions.
   Alpine manages the active tab: clicking a tab switches panels, arrow
   keys move focus between tabs (roving tabindex), and panels toggle via
   the [hidden] attribute so the server-rendered markup is correct even
   before Alpine loads (and with JavaScript disabled entirely). *)

type tab = { id : string; label : string; panel : unit -> JSX.element }

let tab_button ~(active : string) (tab : tab) =
  let is_active = String.equal tab.id active in
  let id = Alpine_util.escape_sq tab.id in
  let attrs =
    [
      ("class", `String "ocelot-tabs__tab");
      ("role", `String "tab");
      ("type", `String "button");
      ("id", `String ("tab-" ^ tab.id));
      ("aria-controls", `String ("panel-" ^ tab.id));
      ("aria-selected", `String (if is_active then "true" else "false"));
      ( ":aria-selected",
        `String (Printf.sprintf "active === '%s' ? 'true' : 'false'" id) );
      ("tabindex", `String (if is_active then "0" else "-1"));
      (":tabindex", `String (Printf.sprintf "active === '%s' ? '0' : '-1'" id));
      ("@click", `String (Printf.sprintf "active = '%s'" id));
      ( "@keydown.arrow-right.prevent",
        `String
          "($el.nextElementSibling || \
           $el.parentElement.firstElementChild).focus()" );
      ( "@keydown.arrow-left.prevent",
        `String
          "($el.previousElementSibling || \
           $el.parentElement.lastElementChild).focus()" );
      ( "@keydown.home.prevent",
        `String "$el.parentElement.firstElementChild.focus()" );
      ( "@keydown.end.prevent",
        `String "$el.parentElement.lastElementChild.focus()" );
    ]
  in
  JSX.node "button" attrs [ JSX.string tab.label ]

let tab_panel ~(active : string) (tab : tab) =
  let is_active = String.equal tab.id active in
  let id = Alpine_util.escape_sq tab.id in
  let attrs =
    [
      ("class", `String "ocelot-tabs__panel");
      ("role", `String "tabpanel");
      ("id", `String ("panel-" ^ tab.id));
      ("aria-labelledby", `String ("tab-" ^ tab.id));
      (":hidden", `String (Printf.sprintf "active !== '%s'" id));
    ]
  in
  let attrs = if is_active then attrs else ("hidden", `Bool true) :: attrs in
  JSX.node "div" attrs [ tab.panel () ]

let[@ocelot.htmx] createElement ?(class_ = "") ?(aria_label = "Tabs")
    ?(active_tab : string option) ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) ~(tabs : tab list) () =
  let active =
    match active_tab with
    | Some id -> id
    | None -> ( match tabs with t :: _ -> t.id | [] -> "")
  in
  let x_data =
    Printf.sprintf "{ active: '%s' }" (Alpine_util.escape_sq active)
  in
  let tab_list =
    JSX.node "div"
      [
        ("class", `String "ocelot-tabs__list");
        ("role", `String "tablist");
        ("aria-label", `String aria_label);
      ]
      (List.map (tab_button ~active) tabs)
  in
  let panels = List.map (tab_panel ~active) tabs in
  let class_str = Html_util.class_value [ "ocelot-tabs"; class_ ] in
  JSX.node "div"
    (("class", `String class_str) :: ("x-data", `String x_data) :: attrs)
    ((tab_list :: panels) @ [ children ])

let make = createElement
