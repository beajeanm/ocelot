(* Calendar — a grid of dates for viewing a month and selecting one or
    more days.

    Pure server-side rendering: the grid is a real HTML table (sr-only
    caption, weekday header row, one row per week) and each day is a
    button. Give [name] to make the day buttons submit their date as an
    ISO value ([YYYY-MM-DD]); selection state is whatever you render —
    days in [selected] get [aria-selected] plus the selected style, so
    multi-day selection is just a longer list.

    Month navigation is a server round-trip: pass [prev_href] and
    [next_href] and the header renders accessible previous/next links.

    Date math (leap years, month lengths, weekday of a date) is pure
    arithmetic on the proleptic Gregorian calendar — no [Unix] time, no
    impurity, deterministic tests. *)

type week_start = Mon | Sun

let month_names =
  [|
    "January";
    "February";
    "March";
    "April";
    "May";
    "June";
    "July";
    "August";
    "September";
    "October";
    "November";
    "December";
  |]

let weekday_names =
  [|
    "Monday"; "Tuesday"; "Wednesday"; "Thursday"; "Friday"; "Saturday"; "Sunday";
  |]

let is_leap_year y = (y mod 4 = 0 && y mod 100 <> 0) || y mod 400 = 0

let days_in_month y m =
  match m with
  | 2 -> if is_leap_year y then 29 else 28
  | 4 | 6 | 9 | 11 -> 30
  | _ -> 31

(* Days since 1970-01-01 — Howard Hinnant's [days_from_civil]. *)
let days_from_civil y m d =
  let y' = if m <= 2 then y - 1 else y in
  let era = (if y' >= 0 then y' else y' - 399) / 400 in
  let yoe = y' - (era * 400) in
  let mp = (m + 9) mod 12 in
  let doy = (((153 * mp) + 2) / 5) + d - 1 in
  let doe = (yoe * 365) + (yoe / 4) - (yoe / 100) + doy in
  (era * 146097) + doe - 719468

(* Weekday of a date: 0 = Sunday .. 6 = Saturday (1970-01-01 was a
   Thursday). *)
let weekday y m d = (days_from_civil y m d + 4) mod 7

(* Short and full weekday header labels for a given week start. *)
let weekday_labels = function
  | Mon ->
      [|
        ("Mo", "Monday");
        ("Tu", "Tuesday");
        ("We", "Wednesday");
        ("Th", "Thursday");
        ("Fr", "Friday");
        ("Sa", "Saturday");
        ("Su", "Sunday");
      |]
  | Sun ->
      [|
        ("Su", "Sunday");
        ("Mo", "Monday");
        ("Tu", "Tuesday");
        ("We", "Wednesday");
        ("Th", "Thursday");
        ("Fr", "Friday");
        ("Sa", "Saturday");
      |]

let createElement ~year ~month ?name ?(selected = []) ?(today : int option)
    ?(disabled = []) ?(week_start = Mon) ?prev_href ?next_href ?(class_ = "")
    ?(children = JSX.null) () =
  ignore children;
  let month = max 1 (min 12 month) in
  let month_name = month_names.(month - 1) in
  let title = Printf.sprintf "%s %d" month_name year in
  let class_str = Html_util.class_value [ "ocelot-calendar"; class_ ] in
  let n_days = days_in_month year month in
  let leading =
    match week_start with
    | Mon -> (weekday year month 1 + 6) mod 7
    | Sun -> weekday year month 1
  in
  let trailing = (7 - ((leading + n_days) mod 7)) mod 7 in
  (* One entry per grid cell: [None] for padding, [Some d] for a day. *)
  let cells =
    List.init leading (fun _ -> None)
    @ List.init n_days (fun i -> Some (i + 1))
    @ List.init trailing (fun _ -> None)
  in
  let cell day =
    match day with
    | None ->
        JSX.node "td"
          [
            ( "class",
              `String "ocelot-calendar__cell ocelot-calendar__cell--empty" );
            ("role", `String "gridcell");
            ("aria-hidden", `String "true");
          ]
          []
    | Some d ->
        let iso = Printf.sprintf "%04d-%02d-%02d" year month d in
        let is_selected = List.mem d selected in
        let is_disabled = List.mem d disabled in
        let btn_class =
          Html_util.class_value
            ([
               "ocelot-calendar__day";
               (if is_selected then "ocelot-calendar__day--selected" else "");
               (if Some d = today then "ocelot-calendar__day--today" else "");
             ]
              : string list)
        in
        let btn_attrs =
          ref
            [
              ("class", `String btn_class);
              ( "type",
                `String
                  (match name with Some _ -> "submit" | None -> "button") );
              ( "aria-label",
                `String (Printf.sprintf "%d %s %d" d month_name year) );
            ]
        in
        (match name with
        | Some n ->
            btn_attrs :=
              ("value", `String iso) :: ("name", `String n) :: !btn_attrs
        | None -> ());
        if is_disabled then btn_attrs := ("disabled", `Bool true) :: !btn_attrs;
        let button =
          JSX.node "button" (List.rev !btn_attrs)
            [ JSX.string (string_of_int d) ]
        in
        let td_attrs =
          ref
            [
              ("class", `String "ocelot-calendar__cell");
              ("role", `String "gridcell");
            ]
        in
        if is_selected then
          td_attrs := ("aria-selected", `String "true") :: !td_attrs;
        if Some d = today then
          td_attrs := ("aria-current", `String "date") :: !td_attrs;
        if is_disabled then
          td_attrs := ("aria-disabled", `String "true") :: !td_attrs;
        JSX.node "td" (List.rev !td_attrs) [ button ]
  in
  let cells = Array.of_list cells in
  let n_weeks = (Array.length cells + 6) / 7 in
  let rows =
    List.init n_weeks (fun w ->
        let week_cells = Array.to_list (Array.sub cells (w * 7) 7) in
        JSX.node "tr" [] (List.map cell week_cells))
  in
  (* Header: prev/next links (server round-trips) around the month title. *)
  let nav href label arrow =
    JSX.node "a"
      [
        ("class", `String "ocelot-calendar__nav");
        ("href", `String href);
        ("aria-label", `String label);
      ]
      [ JSX.string arrow ]
  in
  let header =
    JSX.node "div"
      [ ("class", `String "ocelot-calendar__header") ]
      (List.filter_map
         (fun x -> x)
         [
           Option.map (fun href -> nav href "Previous month" "‹") prev_href;
           Some
             (JSX.node "div"
                [ ("class", `String "ocelot-calendar__title") ]
                [ JSX.string title ]);
           Option.map (fun href -> nav href "Next month" "›") next_href;
         ])
  in
  let caption =
    JSX.node "caption"
      [ ("class", `String "ocelot-sr-only") ]
      [ JSX.string title ]
  in
  let labels = weekday_labels week_start in
  let head_row =
    JSX.node "tr" []
      (Array.to_list
         (Array.map
            (fun (short, full) ->
              JSX.node "th"
                [
                  ("class", `String "ocelot-calendar__weekday");
                  ("scope", `String "col");
                  ("abbr", `String full);
                ]
                [ JSX.string short ])
            labels))
  in
  let grid =
    JSX.node "table"
      [ ("class", `String "ocelot-calendar__grid"); ("role", `String "grid") ]
      [ caption; JSX.node "thead" [] [ head_row ]; JSX.node "tbody" [] rows ]
  in
  JSX.node "div" [ ("class", `String class_str) ] [ header; grid ]

let make = createElement
