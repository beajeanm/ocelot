(* Box — layout primitive with spacing, border, radius, and shadow. *)

type padding = P0 | P1 | P2 | P3 | P4 | P5 | P6 | P8 | P10 | P12
type margin = M0 | M1 | M2 | M3 | M4 | M5 | M6 | M8 | M10 | M12
type radius = R_sm | R_md | R_lg
type shadow = S_sm | S_md | S_lg

let padding_to_string = function
  | P0 -> "ocelot-box--padding-0"
  | P1 -> "ocelot-box--padding-1"
  | P2 -> "ocelot-box--padding-2"
  | P3 -> "ocelot-box--padding-3"
  | P4 -> "ocelot-box--padding-4"
  | P5 -> "ocelot-box--padding-5"
  | P6 -> "ocelot-box--padding-6"
  | P8 -> "ocelot-box--padding-8"
  | P10 -> "ocelot-box--padding-10"
  | P12 -> "ocelot-box--padding-12"

let margin_to_string = function
  | M0 -> "ocelot-box--margin-0"
  | M1 -> "ocelot-box--margin-1"
  | M2 -> "ocelot-box--margin-2"
  | M3 -> "ocelot-box--margin-3"
  | M4 -> "ocelot-box--margin-4"
  | M5 -> "ocelot-box--margin-5"
  | M6 -> "ocelot-box--margin-6"
  | M8 -> "ocelot-box--margin-8"
  | M10 -> "ocelot-box--margin-10"
  | M12 -> "ocelot-box--margin-12"

let radius_to_string = function
  | R_sm -> "ocelot-box--radius-sm"
  | R_md -> "ocelot-box--radius-md"
  | R_lg -> "ocelot-box--radius-lg"

let shadow_to_string = function
  | S_sm -> "ocelot-box--shadow-sm"
  | S_md -> "ocelot-box--shadow-md"
  | S_lg -> "ocelot-box--shadow-lg"

let class_of_option f opt = Option.map f opt

let createElement ?padding ?margin ?radius ?shadow ?border ?bg ?(class_ = "")
    ?(children = JSX.null) () =
  let classes = ref [ "ocelot-box"; class_ ] in
  let add_opt f opt = Option.iter (fun v -> classes := f v :: !classes) opt in
  add_opt padding_to_string padding;
  add_opt margin_to_string margin;
  add_opt radius_to_string radius;
  add_opt shadow_to_string shadow;
  (match border with
  | Some `subtle -> classes := "ocelot-box--border" :: !classes
  | Some `strong -> classes := "ocelot-box--border-strong" :: !classes
  | None -> ());
  (match bg with
  | Some `surface -> classes := "ocelot-box--bg-surface" :: !classes
  | Some `surface_raised ->
      classes := "ocelot-box--bg-surface-raised" :: !classes
  | Some `surface_muted -> classes := "ocelot-box--bg-surface-muted" :: !classes
  | Some `primary -> classes := "ocelot-box--bg-primary" :: !classes
  | None -> ());
  let class_str = Html_util.class_value !classes in
  JSX.node "div" [ ("class", `String class_str) ] [ children ]

let make = createElement
