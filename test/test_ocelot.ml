open Ocelot

let html_contains html substring =
  let sub_len = String.length substring in
  let html_len = String.length html in
  let rec aux i =
    i + sub_len <= html_len
    && (String.sub html i sub_len = substring || aux (i + 1))
  in
  aux 0

let check_contains name html substring =
  Alcotest.(check bool) name true (html_contains html substring)

let render el = JSX.render el

(* --- Foundation --- *)

let test_button_primary () =
  let html =
    render
      (Button.createElement ~variant:Primary ~children:(JSX.string "Click") ())
  in
  check_contains "button class" html "ocelot-button";
  check_contains "button variant" html "ocelot-button--primary";
  check_contains "button text" html "Click"

let test_button_disabled () =
  let html =
    render
      (Button.createElement ~variant:Primary ~disabled:true
         ~children:(JSX.string "Nope") ())
  in
  check_contains "disabled attr" html "disabled"

let test_box_padding () =
  let html = render (Box.createElement ~padding:P4 ~children:JSX.null ()) in
  check_contains "padding class" html "ocelot-box--padding-4"

let test_css_render () =
  let html = render (Css.render ()) in
  check_contains "style tag" html "<style>";
  check_contains "light theme scope" html "[data-ocelot-theme=\"light\"]";
  check_contains "dark theme scope" html "[data-ocelot-theme=\"dark\"]";
  check_contains "x-cloak rule" html "[x-cloak]";
  check_contains "toast css" html "ocelot-toast-container";
  check_contains "dropdown css" html "ocelot-dropdown__menu"

let test_theme_light () =
  let css = Theme.theme_to_css Theme.default_light in
  check_contains "primary var" css "--ocelot-primary"

let test_theme_dark () =
  let css = Theme.theme_to_css Theme.default_dark in
  check_contains "primary var" css "--ocelot-primary"

let test_alpine_script () =
  let html = render (Alpine.script ()) in
  check_contains "focus plugin" html "@alpinejs/focus";
  check_contains "alpine core" html "alpinejs@";
  check_contains "deferred" html "defer"

(* --- Static components --- *)

let test_alert_role () =
  let html =
    render
      (Alert.createElement ~variant:Success ~children:(JSX.string "Saved!") ())
  in
  check_contains "role alert" html "role=\"alert\"";
  check_contains "variant class" html "ocelot-alert--success"

let test_link_external () =
  let html =
    render
      (Link.createElement ~href:"https://example.com" ~external_:true
         ~children:(JSX.string "Ext") ())
  in
  check_contains "target blank" html "target=\"_blank\"";
  check_contains "rel noopener" html "noopener noreferrer"

let test_input_attrs () =
  let html =
    render
      (Input.createElement ~type_:"email" ~name:"email" ~id:"email"
         ~placeholder:"you@example.com" ~required:true ())
  in
  check_contains "input tag" html "<input";
  check_contains "type email" html "type=\"email\"";
  check_contains "required" html "required"

let test_select_disabled_option () =
  let options =
    [
      { Select.value = "a"; label = "Alice"; disabled = false };
      { Select.value = "b"; label = "Bob"; disabled = true };
    ]
  in
  let html = render (Select.createElement ~name:"user" ~options ()) in
  check_contains "select tag" html "<select";
  check_contains "option a" html "<option value=\"a\">Alice</option>";
  check_contains "disabled option" html
    "<option value=\"b\" disabled>Bob</option>"

let test_table_structure () =
  let head =
    Table.Head.createElement
      ~children:
        (JSX.list
           [ Table.HeaderCell.createElement ~children:(JSX.string "Name") () ])
      ()
  in
  let body =
    Table.Body.createElement
      ~children:
        (JSX.list
           [
             Table.Row.createElement
               ~children:
                 (JSX.list
                    [
                      Table.Cell.createElement ~children:(JSX.string "Alice") ();
                    ])
               ();
           ])
      ()
  in
  let html =
    render (Table.createElement ~children:(JSX.list [ head; body ]) ())
  in
  check_contains "thead" html "<thead";
  check_contains "scope col" html "scope=\"col\"";
  check_contains "tbody" html "<tbody>"

let test_breadcrumb_aria () =
  let html =
    render
      (Breadcrumb.createElement
         ~children:
           (JSX.list
              [
                Breadcrumb.Item.createElement ~href:"/"
                  ~children:(JSX.string "Home") ();
                Breadcrumb.Item.createElement ~is_current:true
                  ~children:(JSX.string "Here") ();
              ])
         ())
  in
  check_contains "nav label" html "aria-label=\"Breadcrumb\"";
  check_contains "aria current" html "aria-current=\"page\"";
  check_contains "list class" html "ocelot-breadcrumb__list"

let test_pagination_aria () =
  let html =
    render
      (Pagination.createElement
         ~children:
           (JSX.list
              [
                Pagination.Item.createElement ~is_current:true
                  ~children:(JSX.string "1") ();
                Pagination.Ellipsis.createElement ();
              ])
         ())
  in
  check_contains "nav label" html "aria-label=\"Pagination\"";
  check_contains "aria current" html "aria-current=\"page\"";
  check_contains "ellipsis" html "…"

(* --- Alpine components --- *)

let test_tabs_aria () =
  let tabs =
    [
      { Tabs.id = "a"; label = "A"; panel = (fun () -> JSX.string "Panel A") };
      { Tabs.id = "b"; label = "B"; panel = (fun () -> JSX.string "Panel B") };
    ]
  in
  let html = render (Tabs.createElement ~tabs ()) in
  check_contains "tablist" html "role=\"tablist\"";
  check_contains "tab role" html "role=\"tab\"";
  check_contains "tabpanel role" html "role=\"tabpanel\"";
  check_contains "selected true" html "aria-selected=\"true\"";
  check_contains "selected false" html "aria-selected=\"false\"";
  check_contains "alpine state" html "x-data=\"{ active: &apos;a&apos; }\"";
  check_contains "reactive selected" html ":aria-selected";
  check_contains "hidden panel" html "<div hidden class=\"ocelot-tabs__panel\"";
  check_contains "arrow keys" html "@keydown.arrow-right.prevent";
  check_contains "aria controls" html "aria-controls=\"panel-b\"";
  check_contains "labelledby" html "aria-labelledby=\"tab-a\""

let test_accordion_aria () =
  let html =
    render
      (Accordion.Item.createElement ~title:"Question?"
         ~children:(JSX.string "Answer.") ())
  in
  check_contains "expanded false" html "aria-expanded=\"false\"";
  check_contains "reactive expanded" html ":aria-expanded";
  check_contains "hidden panel" html "<div hidden";
  check_contains "alpine state" html "x-data=\"{ open: false }\"";
  check_contains "controls panel" html "aria-controls="

let test_accordion_open () =
  let html =
    render
      (Accordion.Item.createElement ~open_:true ~title:"Q"
         ~children:(JSX.string "A") ())
  in
  check_contains "expanded true" html "aria-expanded=\"true\"";
  check_contains "open state" html "x-data=\"{ open: true }\"";
  match html_contains html "<div hidden" with
  | true -> Alcotest.fail "open panel must not be hidden"
  | false -> ()

let test_modal_aria () =
  let html =
    render
      (Modal.createElement ~title:"Confirm"
         ~trigger:
           (Button.createElement ~variant:Primary ~children:(JSX.string "Go") ())
         ~content:(JSX.string "Are you sure?")
         ())
  in
  check_contains "dialog role" html "role=\"dialog\"";
  check_contains "aria modal" html "aria-modal=\"true\"";
  check_contains "labelledby title" html "aria-labelledby=";
  check_contains "focus trap" html "x-trap.inert.noscroll";
  check_contains "escape closes" html "@keydown.escape.window";
  check_contains "cloaked" html "x-cloak";
  check_contains "close label" html "aria-label=\"Close dialog\""

let test_toast_aria () =
  let html =
    render
      (Toast.createElement ~variant:Success ~children:(JSX.string "Saved") ())
  in
  check_contains "status role" html "role=\"status\"";
  check_contains "live polite" html "aria-live=\"polite\"";
  check_contains "auto dismiss" html "setTimeout";
  check_contains "dismiss button" html "aria-label=\"Dismiss notification\""

let test_toast_sticky () =
  let html =
    render (Toast.createElement ~duration:0 ~children:(JSX.string "Sticky") ())
  in
  match html_contains html "setTimeout" with
  | true -> Alcotest.fail "duration 0 must not auto-dismiss"
  | false -> ()

let test_tooltip_aria () =
  let html =
    render
      (Tooltip.createElement ~text:"A helpful tip" ~focusable:true
         ~children:(JSX.string "Trigger") ())
  in
  check_contains "tooltip role" html "role=\"tooltip\"";
  check_contains "describedby" html "aria-describedby=";
  check_contains "hover show" html "@mouseenter";
  check_contains "focus show" html "@focusin";
  check_contains "escape hides" html "@keydown.escape";
  check_contains "id link" html "ocelot-tip-"

let test_dropdown_aria () =
  let html =
    render
      (Dropdown.createElement ~placeholder:"Pick..."
         ~options:[ ("a", "Alpha"); ("b", "Beta") ]
         ())
  in
  check_contains "listbox role" html "role=\"listbox\"";
  check_contains "option role" html "role=\"option\"";
  check_contains "haspopup" html "aria-haspopup=\"listbox\"";
  check_contains "activedescendant" html ":aria-activedescendant";
  check_contains "reactive expanded" html ":aria-expanded";
  check_contains "x-for" html "x-for=\"(item, i) in items\"";
  check_contains "enter selects" html "@keydown.enter.prevent";
  check_contains "outside closes" html "@click.outside";
  check_contains "items state" html
    "items: [ { value: &apos;a&apos;, label: &apos;Alpha&apos; }"

let () =
  Alcotest.run "Ocelot"
    [
      ( "foundation",
        [
          Alcotest.test_case "button primary" `Quick test_button_primary;
          Alcotest.test_case "button disabled" `Quick test_button_disabled;
          Alcotest.test_case "box padding" `Quick test_box_padding;
          Alcotest.test_case "css render" `Quick test_css_render;
          Alcotest.test_case "theme light" `Quick test_theme_light;
          Alcotest.test_case "theme dark" `Quick test_theme_dark;
          Alcotest.test_case "alpine script" `Quick test_alpine_script;
        ] );
      ( "static components",
        [
          Alcotest.test_case "alert role" `Quick test_alert_role;
          Alcotest.test_case "link external" `Quick test_link_external;
          Alcotest.test_case "input attrs" `Quick test_input_attrs;
          Alcotest.test_case "select disabled option" `Quick
            test_select_disabled_option;
          Alcotest.test_case "table structure" `Quick test_table_structure;
          Alcotest.test_case "breadcrumb aria" `Quick test_breadcrumb_aria;
          Alcotest.test_case "pagination aria" `Quick test_pagination_aria;
        ] );
      ( "alpine components",
        [
          Alcotest.test_case "tabs aria" `Quick test_tabs_aria;
          Alcotest.test_case "accordion aria" `Quick test_accordion_aria;
          Alcotest.test_case "accordion open" `Quick test_accordion_open;
          Alcotest.test_case "modal aria" `Quick test_modal_aria;
          Alcotest.test_case "toast aria" `Quick test_toast_aria;
          Alcotest.test_case "toast sticky" `Quick test_toast_sticky;
          Alcotest.test_case "tooltip aria" `Quick test_tooltip_aria;
          Alcotest.test_case "dropdown aria" `Quick test_dropdown_aria;
        ] );
    ]
