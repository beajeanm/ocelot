(* Theme module — design tokens and CSS generation

   Ocelot's theme system is built on CSS Custom Properties.
   Each theme is an OCaml record that is converted to a block of CSS
   variable definitions. Components reference these variables in their
   class-based styles (embedded in the library).

   Switching themes at runtime is done by toggling the `data-ocelot-theme`
   attribute on the root element (or any ancestor). Light and dark themes
   ship by default. *)

type color = string

type t = {
  (* Colors *)
  primary : color;
  primary_hover : color;
  primary_active : color;
  secondary : color;
  secondary_hover : color;
  danger : color;
  danger_hover : color;
  success : color;
  warning : color;
  info : color;
  background : color;
  surface : color;
  surface_raised : color;
  surface_muted : color;
  border : color;
  border_strong : color;
  text_primary : color;
  text_secondary : color;
  text_heading : color;
  text_muted : color;
  (* Typography *)
  font_body : string;
  font_mono : string;
  font_size_sm : string;
  font_size_md : string;
  font_size_lg : string;
  font_size_xl : string;
  (* Spacing *)
  spacing_unit : string;
  radius_sm : string;
  radius_md : string;
  radius_lg : string;
  (* Shadows *)
  shadow_sm : string;
  shadow_md : string;
  shadow_lg : string;
  (* Misc *)
  focus_ring : color;
  disabled_opacity : string;
}
(** Design tokens for a complete theme. *)

let color_to_css c = c
let css_variable name value = Printf.sprintf "  --ocelot-%s: %s;" name value

let theme_to_css theme =
  let v = css_variable in
  let c name (color : color) = v name (color_to_css color) in
  String.concat "\n"
    [
      (* Colors *)
      c "primary" theme.primary;
      c "primary-hover" theme.primary_hover;
      c "primary-active" theme.primary_active;
      c "secondary" theme.secondary;
      c "secondary-hover" theme.secondary_hover;
      c "danger" theme.danger;
      c "danger-hover" theme.danger_hover;
      c "success" theme.success;
      c "warning" theme.warning;
      c "info" theme.info;
      c "background" theme.background;
      c "surface" theme.surface;
      c "surface-raised" theme.surface_raised;
      c "surface-muted" theme.surface_muted;
      c "border" theme.border;
      c "border-strong" theme.border_strong;
      c "text-primary" theme.text_primary;
      c "text-secondary" theme.text_secondary;
      c "text-heading" theme.text_heading;
      c "text-muted" theme.text_muted;
      (* Typography *)
      v "font-body" theme.font_body;
      v "font-mono" theme.font_mono;
      v "font-size-sm" theme.font_size_sm;
      v "font-size-md" theme.font_size_md;
      v "font-size-lg" theme.font_size_lg;
      v "font-size-xl" theme.font_size_xl;
      (* Spacing *)
      v "spacing-unit" theme.spacing_unit;
      v "radius-sm" theme.radius_sm;
      v "radius-md" theme.radius_md;
      v "radius-lg" theme.radius_lg;
      (* Shadows *)
      v "shadow-sm" theme.shadow_sm;
      v "shadow-md" theme.shadow_md;
      v "shadow-lg" theme.shadow_lg;
      (* Misc *)
      c "focus-ring" theme.focus_ring;
      v "disabled-opacity" theme.disabled_opacity;
    ]

let default_light =
  {
    primary = "oklch(55% 0.18 250)";
    primary_hover = "oklch(48% 0.18 250)";
    primary_active = "oklch(42% 0.18 250)";
    secondary = "oklch(60% 0.05 250)";
    secondary_hover = "oklch(55% 0.05 250)";
    danger = "oklch(55% 0.18 25)";
    danger_hover = "oklch(48% 0.18 25)";
    success = "oklch(60% 0.15 150)";
    warning = "oklch(70% 0.12 80)";
    info = "oklch(60% 0.15 220)";
    background = "oklch(98% 0.005 80)";
    surface = "oklch(100% 0 0)";
    surface_raised = "oklch(96% 0.005 80)";
    surface_muted = "oklch(94% 0.005 80)";
    border = "oklch(85% 0.02 80)";
    border_strong = "oklch(70% 0.03 80)";
    text_primary = "oklch(25% 0.02 80)";
    text_secondary = "oklch(45% 0.02 80)";
    text_heading = "oklch(20% 0.03 80)";
    text_muted = "oklch(60% 0.02 80)";
    font_body = "system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif";
    font_mono = "'IBM Plex Mono', 'SFMono-Regular', Consolas, monospace";
    font_size_sm = "0.875rem";
    font_size_md = "1rem";
    font_size_lg = "1.125rem";
    font_size_xl = "1.5rem";
    spacing_unit = "0.25rem";
    radius_sm = "0.25rem";
    radius_md = "0.5rem";
    radius_lg = "0.75rem";
    shadow_sm = "0 1px 2px 0 oklch(0% 0 0 / 0.05)";
    shadow_md =
      "0 4px 6px -1px oklch(0% 0 0 / 0.1), 0 2px 4px -2px oklch(0% 0 0 / 0.1)";
    shadow_lg =
      "0 10px 15px -3px oklch(0% 0 0 / 0.1), 0 4px 6px -4px oklch(0% 0 0 / 0.1)";
    focus_ring = "oklch(55% 0.18 250 / 0.4)";
    disabled_opacity = "0.6";
  }

let default_dark =
  {
    primary = "oklch(70% 0.15 250)";
    primary_hover = "oklch(75% 0.15 250)";
    primary_active = "oklch(80% 0.15 250)";
    secondary = "oklch(60% 0.05 250)";
    secondary_hover = "oklch(65% 0.05 250)";
    danger = "oklch(65% 0.15 25)";
    danger_hover = "oklch(70% 0.15 25)";
    success = "oklch(70% 0.12 150)";
    warning = "oklch(75% 0.1 80)";
    info = "oklch(70% 0.12 220)";
    background = "oklch(20% 0.02 250)";
    surface = "oklch(25% 0.02 250)";
    surface_raised = "oklch(30% 0.02 250)";
    surface_muted = "oklch(22% 0.02 250)";
    border = "oklch(35% 0.02 250)";
    border_strong = "oklch(45% 0.03 250)";
    text_primary = "oklch(85% 0.02 250)";
    text_secondary = "oklch(70% 0.02 250)";
    text_heading = "oklch(90% 0.02 250)";
    text_muted = "oklch(55% 0.02 250)";
    font_body = "system-ui, -apple-system, 'Segoe UI', Roboto, sans-serif";
    font_mono = "'IBM Plex Mono', 'SFMono-Regular', Consolas, monospace";
    font_size_sm = "0.875rem";
    font_size_md = "1rem";
    font_size_lg = "1.125rem";
    font_size_xl = "1.5rem";
    spacing_unit = "0.25rem";
    radius_sm = "0.25rem";
    radius_md = "0.5rem";
    radius_lg = "0.75rem";
    shadow_sm = "0 1px 2px 0 oklch(0% 0 0 / 0.3)";
    shadow_md =
      "0 4px 6px -1px oklch(0% 0 0 / 0.4), 0 2px 4px -2px oklch(0% 0 0 / 0.4)";
    shadow_lg =
      "0 10px 15px -3px oklch(0% 0 0 / 0.5), 0 4px 6px -4px oklch(0% 0 0 / 0.5)";
    focus_ring = "oklch(70% 0.15 250 / 0.4)";
    disabled_opacity = "0.5";
  }
