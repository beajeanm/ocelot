(* Dropdown — custom listbox driven by Alpine.js.

   A styled alternative to the native [Select]: opens on click, moves the
   active option with arrow keys (Home/End supported), selects with Enter
   or click, and closes with Escape or an outside click. The trigger keeps
   DOM focus and exposes [aria-haspopup="listbox"] / [aria-expanded]; the
   menu is a [role="listbox"] whose [aria-activedescendant] tracks the
   active [role="option"].

   Options are [(value, label)] pairs; they are serialized into the
   [x-data] state and rendered client-side via [x-for], so this component
   requires JavaScript. Use the native [Select] when it must work without. *)

let option_to_json ((value, label) : string * string) =
  Printf.sprintf "{ value: '%s', label: '%s' }"
    (Alpine_util.escape_sq value)
    (Alpine_util.escape_sq label)

let[@ocelot.htmx] createElement ?(class_ = "") ?(aria_label = "Options")
    ?(id : string option) ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) ~placeholder ~(options : (string * string) list) () =
  let dd_id =
    Option.value id ~default:(Alpine_util.derived_id "ocelot-dd-" placeholder)
  in
  let dd_id_js = Alpine_util.escape_sq dd_id in
  let count = List.length options in
  let items = String.concat ", " (List.map option_to_json options) in
  let x_data =
    Printf.sprintf
      "{ open: false, active: 0, selectedItem: null, items: [ %s ] }" items
  in
  let root_attrs =
    [
      ("class", `String (Html_util.class_value [ "ocelot-dropdown"; class_ ]));
      ("x-data", `String x_data);
      ("@keydown.escape", `String "open = false");
      ("@click.outside", `String "open = false");
      ( "@keydown.arrow-down.prevent",
        `String
          (Printf.sprintf "if (open) { active = (active + 1) %% %d }" count) );
      ( "@keydown.arrow-up.prevent",
        `String
          (Printf.sprintf "if (open) { active = (active - 1 + %d) %% %d }" count
             count) );
      ("@keydown.home.prevent", `String "if (open) { active = 0 }");
      ( "@keydown.end.prevent",
        `String (Printf.sprintf "if (open) { active = %d - 1 }" count) );
      ( "@keydown.enter.prevent",
        `String
          "if (open && items[active]) { selectedItem = items[active]; open = \
           false }" );
    ]
  in
  let trigger =
    JSX.node "button"
      [
        ("type", `String "button");
        ( "class",
          `String
            "ocelot-button ocelot-button--secondary ocelot-dropdown__trigger" );
        ("aria-haspopup", `String "listbox");
        ("aria-expanded", `String "false");
        (":aria-expanded", `String "open ? 'true' : 'false'");
        ("@click", `String "open = !open; active = 0");
      ]
      [
        JSX.node "span"
          [
            ("class", `String "ocelot-dropdown__label");
            ( "x-text",
              `String
                (Printf.sprintf "selectedItem ? selectedItem.label : '%s'"
                   (Alpine_util.escape_sq placeholder)) );
          ]
          [ JSX.string placeholder ];
        JSX.node "span"
          [
            ("class", `String "ocelot-dropdown__icon");
            ("aria-hidden", `String "true");
          ]
          [ JSX.string "▼" ];
      ]
  in
  let option_li =
    JSX.node "li"
      [
        ("role", `String "option");
        (":id", `String (Printf.sprintf "'%s-opt-' + i" dd_id_js));
        ( ":aria-selected",
          `String
            "selectedItem && selectedItem.value === item.value ? 'true' : \
             'false'" );
        ( ":class",
          `String
            "{ 'ocelot-dropdown__option--active': active === i, \
             'ocelot-dropdown__option--selected': selectedItem && \
             selectedItem.value === item.value }" );
        ("@click", `String "selectedItem = item; open = false");
        ("@mousemove", `String "active = i");
      ]
      [ JSX.node "span" [ ("x-text", `String "item.label") ] [ JSX.string "" ] ]
  in
  let option_template =
    JSX.node "template"
      [
        ("x-for", `String "(item, i) in items"); (":key", `String "item.value");
      ]
      [ option_li ]
  in
  let menu =
    JSX.node "ul"
      [
        ("class", `String "ocelot-dropdown__menu");
        ("role", `String "listbox");
        ("aria-label", `String aria_label);
        ( ":aria-activedescendant",
          `String (Printf.sprintf "'%s-opt-' + active" dd_id_js) );
        ("x-show", `String "open");
        ("x-cloak", `Bool true);
        ("tabindex", `String "-1");
      ]
      [ option_template ]
  in
  JSX.node "div" (root_attrs @ attrs) [ trigger; menu; children ]

let make = createElement
