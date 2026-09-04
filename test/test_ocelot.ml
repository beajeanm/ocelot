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

let test_button_htmx () =
  let html =
    render
      (Button.createElement ~hx_get:"/api/click" ~hx_target:"#result"
         ~children:(JSX.string "Click") ())
  in
  check_contains "hx-get attr" html "hx-get=\"/api/click\"";
  check_contains "hx-target attr" html "hx-target=\"#result\""

let test_input_htmx () =
  let html =
    render
      (Input.createElement ~hx_post:"/api/search"
         ~hx_trigger:"keyup changed delay:500ms" ~type_:"search"
         ~placeholder:"Search..." ())
  in
  check_contains "hx-post attr" html "hx-post=\"/api/search\"";
  check_contains "hx-trigger attr" html
    "hx-trigger=\"keyup changed delay:500ms\"";
  check_contains "input tag" html "<input"

let test_checkbox_htmx () =
  let html =
    render
      (Checkbox.createElement ~hx_get:"/api/toggle" ~name:"notify" ~checked:true
         ~children:(JSX.string "Enable notifications")
         ())
  in
  check_contains "hx-get attr" html "hx-get=\"/api/toggle\"";
  check_contains "checkbox type" html "type=\"checkbox\"";
  check_contains "checked attr" html "checked"

let test_alert_htmx () =
  let html =
    render
      (Alert.createElement ~variant:Success ~hx_swap:"outerHTML"
         ~children:(JSX.string "Saved!") ())
  in
  check_contains "hx-swap attr" html "hx-swap=\"outerHTML\"";
  check_contains "role alert" html "role=\"alert\"";
  check_contains "variant class" html "ocelot-alert--success"

let test_box_htmx () =
  let html =
    render
      (Box.createElement ~hx_get:"/api/content" ~hx_target:"#main"
         ~children:(JSX.string "Loading...") ())
  in
  check_contains "hx-get attr" html "hx-get=\"/api/content\"";
  check_contains "hx-target attr" html "hx-target=\"#main\"";
  check_contains "box class" html "ocelot-box"

let test_escape_hatch () =
  (* Verify the old attrs=[Hx.get ...] escape hatch still works *)
  let html =
    render
      (Button.createElement
         ~attrs:[ ("hx-get", `String "/api/old") ]
         ~children:(JSX.string "Old") ())
  in
  check_contains "escape hatch hx-get" html "hx-get=\"/api/old\""

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
    "<option disabled value=\"b\">Bob</option>"

(* --- Form controls & indicators --- *)

let test_checkbox () =
  let html =
    render
      (Checkbox.createElement ~name:"tos" ~value:"accepted" ~checked:true
         ~children:(JSX.string "Accept terms")
         ())
  in
  check_contains "checkbox type" html "type=\"checkbox\"";
  check_contains "checked attr" html "checked";
  check_contains "label text" html "Accept terms";
  check_contains "box class" html "ocelot-checkbox__box";
  check_contains "indicator class" html "ocelot-checkbox__indicator";
  check_contains "decorative aria-hidden" html "aria-hidden=\"true\""

let test_checkbox_disabled () =
  let html = render (Checkbox.createElement ~name:"x" ~disabled:true ()) in
  check_contains "disabled attr" html "disabled";
  match html_contains html "ocelot-checkbox__label" with
  | true -> Alcotest.fail "no children should mean no label span"
  | false -> ()

let test_radio_group () =
  let html =
    render
      (Radio_group.createElement ~label:"Plan"
         ~children:
           (JSX.list
              [
                Radio_group.Item.createElement ~name:"plan" ~value:"free"
                  ~checked:true ~children:(JSX.string "Free") ();
                Radio_group.Item.createElement ~name:"plan" ~value:"pro"
                  ~children:(JSX.string "Pro") ();
                Radio_group.Item.createElement ~name:"plan" ~value:"enterprise"
                  ~disabled:true ~children:(JSX.string "Enterprise") ();
              ])
         ())
  in
  check_contains "radiogroup role" html "role=\"radiogroup\"";
  check_contains "legend" html "<legend";
  check_contains "group label" html "Plan</legend>";
  check_contains "radio type" html "type=\"radio\"";
  check_contains "radio role label" html "aria-label=\"Plan\"";
  check_contains "checked attr" html "checked";
  check_contains "disabled attr" html "disabled";
  check_contains "circle class" html "ocelot-radio__circle";
  check_contains "dot class" html "ocelot-radio__dot"

let test_radio_group_disabled () =
  let html =
    render
      (Radio_group.createElement ~aria_label:"Pick one" ~disabled:true
         ~children:
           (Radio_group.Item.createElement ~name:"pick" ~value:"a"
              ~children:(JSX.string "A") ())
         ())
  in
  check_contains "fieldset disabled" html " disabled";
  match html_contains html "<legend" with
  | true -> Alcotest.fail "aria_label only must not render a legend"
  | false -> ()

let test_switch () =
  let html =
    render
      (Switch.createElement ~name:"alerts" ~checked:true
         ~children:(JSX.string "Email alerts")
         ())
  in
  check_contains "switch role" html "role=\"switch\"";
  check_contains "checkbox underneath" html "type=\"checkbox\"";
  check_contains "checked attr" html "checked";
  check_contains "label text" html "Email alerts";
  check_contains "track class" html "ocelot-switch__track";
  check_contains "thumb class" html "ocelot-switch__thumb"

let test_progress () =
  let html =
    render (Progress.createElement ~value:0.7 ~aria_label:"Upload" ())
  in
  check_contains "progressbar role" html "role=\"progressbar\"";
  check_contains "valuenow" html "aria-valuenow=\"70\"";
  check_contains "valuemin" html "aria-valuemin=\"0\"";
  check_contains "valuemax" html "aria-valuemax=\"100\"";
  check_contains "aria label" html "aria-label=\"Upload\"";
  check_contains "indicator width" html "width: 70%"

let test_progress_indeterminate () =
  let html = render (Progress.createElement ~indeterminate:true ()) in
  check_contains "indeterminate class" html "ocelot-progress--indeterminate";
  match html_contains html "aria-valuenow" with
  | true -> Alcotest.fail "indeterminate progress must not set aria-valuenow"
  | false -> ()

let test_scroll_area () =
  let html =
    render
      (Scroll_area.createElement ~max_height:"12rem"
         ~children:(JSX.string "Overflowing content")
         ())
  in
  check_contains "scroll class" html "ocelot-scroll-area";
  check_contains "vertical class" html "ocelot-scroll-area--vertical";
  check_contains "max height style" html "max-height: 12rem";
  check_contains "content" html "Overflowing content"

let test_scroll_area_horizontal () =
  let html =
    render (Scroll_area.createElement ~orientation:Both ~children:JSX.null ())
  in
  check_contains "horizontal class" html "ocelot-scroll-area--horizontal";
  check_contains "both classes" html
    "ocelot-scroll-area--vertical ocelot-scroll-area--horizontal"

let test_spinner () =
  let html = render (Spinner.createElement ~size:Lg ()) in
  check_contains "status role" html "role=\"status\"";
  check_contains "default label" html "aria-label=\"Loading\"";
  check_contains "size class" html "ocelot-spinner--lg";
  check_contains "icon class" html "ocelot-spinner__icon"

let test_spinner_with_label () =
  let html =
    render
      (Spinner.createElement ~size:Sm
         ~children:(JSX.string "Fetching data…")
         ())
  in
  check_contains "visible text" html "Fetching data…";
  check_contains "sm class" html "ocelot-spinner--sm";
  match html_contains html "aria-label" with
  | true -> Alcotest.fail "visible text must not duplicate an aria-label"
  | false -> ()

(* --- Calendar --- *)

let count_occurrences html substring =
  let sub_len = String.length substring in
  let html_len = String.length html in
  let rec aux i acc =
    if i + sub_len > html_len then acc
    else if String.sub html i sub_len = substring then
      aux (i + sub_len) (acc + 1)
    else aux (i + 1) acc
  in
  aux 0 0

let test_calendar_structure () =
  (* June 2025 starts on a Sunday. *)
  let html =
    render
      (Calendar.createElement ~year:2025 ~month:6 ~week_start:Calendar.Sun ())
  in
  check_contains "grid role" html "role=\"grid\"";
  check_contains "caption" html
    "<caption class=\"ocelot-sr-only\">June 2025</caption>";
  check_contains "title" html "June 2025</div>";
  check_contains "weekday abbr" html "abbr=\"Sunday\"";
  check_contains "day button" html ">15</button>";
  check_contains "day aria label" html "aria-label=\"15 June 2025\"";
  (* Sunday start + Sunday the 1st: no leading padding, and the 30 days
     end on a Monday, leaving 5 trailing blanks — 5 empty cells total. *)
  Alcotest.(check int)
    "empty cells" 5
    (count_occurrences html "ocelot-calendar__cell--empty")

let test_calendar_monday_start () =
  (* June 2025: 6 leading blanks (Mon start) + 30 days + 6 trailing. *)
  let html = render (Calendar.createElement ~year:2025 ~month:6 ()) in
  Alcotest.(check int)
    "empty cells" 12
    (count_occurrences html "ocelot-calendar__cell--empty");
  (* Regression: the empty-cell class must be merged into a single class
     attribute, not a second one (browsers ignore duplicates). *)
  check_contains "merged empty class" html
    "class=\"ocelot-calendar__cell ocelot-calendar__cell--empty\"";
  Alcotest.(check int)
    "no duplicate class attr" 0
    (count_occurrences html "class=\"ocelot-calendar__cell--empty\"");
  check_contains "mo header first" html "Mo</th>";
  check_contains "su header last" html "Su</th>"

let test_calendar_states () =
  let html =
    render
      (Calendar.createElement ~year:2025 ~month:6 ~name:"date"
         ~selected:[ 3; 15 ] ~today:15 ~disabled:[ 20 ] ())
  in
  check_contains "selected cell" html "aria-selected=\"true\"";
  check_contains "selected class" html "ocelot-calendar__day--selected";
  check_contains "today cell" html "aria-current=\"date\"";
  check_contains "today class" html "ocelot-calendar__day--today";
  check_contains "disabled day" html " disabled";
  check_contains "disabled cell" html "aria-disabled=\"true\"";
  check_contains "submit type" html "type=\"submit\"";
  check_contains "form name" html "name=\"date\"";
  check_contains "iso value" html "value=\"2025-06-15\""

let test_calendar_leap_year () =
  (* February 2024 has 29 days; the 29th must render as a day. *)
  let html = render (Calendar.createElement ~year:2024 ~month:2 ()) in
  check_contains "feb 29" html ">29</button>";
  let html = render (Calendar.createElement ~year:2025 ~month:2 ()) in
  match html_contains html ">29</button>" with
  | true -> Alcotest.fail "2025-02 must not have a 29th"
  | false -> ()

let test_calendar_nav () =
  let html =
    render
      (Calendar.createElement ~year:2025 ~month:6 ~prev_href:"/2025/05"
         ~next_href:"/2025/07" ())
  in
  check_contains "prev link" html "href=\"/2025/05\"";
  check_contains "prev label" html "aria-label=\"Previous month\"";
  check_contains "next link" html "href=\"/2025/07\"";
  check_contains "next label" html "aria-label=\"Next month\""

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
          Alcotest.test_case "button htmx" `Quick test_button_htmx;
          Alcotest.test_case "input htmx" `Quick test_input_htmx;
          Alcotest.test_case "checkbox htmx" `Quick test_checkbox_htmx;
          Alcotest.test_case "alert htmx" `Quick test_alert_htmx;
          Alcotest.test_case "box htmx" `Quick test_box_htmx;
          Alcotest.test_case "escape hatch" `Quick test_escape_hatch;
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
      ( "form controls & indicators",
        [
          Alcotest.test_case "checkbox" `Quick test_checkbox;
          Alcotest.test_case "checkbox disabled" `Quick test_checkbox_disabled;
          Alcotest.test_case "radio group" `Quick test_radio_group;
          Alcotest.test_case "radio group disabled" `Quick
            test_radio_group_disabled;
          Alcotest.test_case "switch" `Quick test_switch;
          Alcotest.test_case "progress" `Quick test_progress;
          Alcotest.test_case "progress indeterminate" `Quick
            test_progress_indeterminate;
          Alcotest.test_case "scroll area" `Quick test_scroll_area;
          Alcotest.test_case "scroll area horizontal" `Quick
            test_scroll_area_horizontal;
          Alcotest.test_case "spinner" `Quick test_spinner;
          Alcotest.test_case "spinner with label" `Quick test_spinner_with_label;
        ] );
      ( "calendar",
        [
          Alcotest.test_case "structure (Sunday start)" `Quick
            test_calendar_structure;
          Alcotest.test_case "monday start alignment" `Quick
            test_calendar_monday_start;
          Alcotest.test_case "selection states" `Quick test_calendar_states;
          Alcotest.test_case "leap year" `Quick test_calendar_leap_year;
          Alcotest.test_case "navigation" `Quick test_calendar_nav;
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
