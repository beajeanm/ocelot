(* Tooltip — driven by Alpine.js.

   Shows on hover and keyboard focus, hides on mouse leave, focus loss,
   and Escape. The trigger is linked to the tooltip content via
   [aria-describedby]. Set [focusable] when the wrapped content is not
   already focusable (plain text) so keyboard users can reach it; when
   wrapping a link or button, leave it off. *)

type position = Top | Bottom

let[@ocelot.htmx] createElement ?(position = Top) ?(class_ = "")
    ?(id : string option) ?(focusable = false)
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) ~text () =
  let tip_id =
    Option.value id ~default:(Alpine_util.derived_id "ocelot-tip-" text)
  in
  let pos_class =
    match position with
    | Top -> "ocelot-tooltip--top"
    | Bottom -> "ocelot-tooltip--bottom"
  in
  let class_str =
    Html_util.class_value [ "ocelot-tooltip"; pos_class; class_ ]
  in
  let trigger_attrs =
    [
      ("class", `String "ocelot-tooltip__trigger");
      ("aria-describedby", `String tip_id);
    ]
    @ if focusable then [ ("tabindex", `String "0") ] else []
  in
  let trigger = JSX.node "span" trigger_attrs [ children ] in
  let content =
    JSX.node "span"
      [
        ("class", `String "ocelot-tooltip__content");
        ("role", `String "tooltip");
        ("id", `String tip_id);
        ("x-show", `String "show");
        ("x-cloak", `Bool true);
        ("x-transition.opacity", `Bool true);
      ]
      [ JSX.string text ]
  in
  JSX.node "span"
    (("class", `String class_str)
    :: ("x-data", `String "{ show: false }")
    :: ("@mouseenter", `String "show = true")
    :: ("@mouseleave", `String "show = false")
    :: ("@focusin", `String "show = true")
    :: ("@focusout", `String "show = false")
    :: ("@keydown.escape", `String "show = false")
    :: attrs)
    [ trigger; content ]

let make = createElement
