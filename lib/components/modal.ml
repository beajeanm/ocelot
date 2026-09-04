(* Modal / Dialog — driven by Alpine.js.

   Wraps a [trigger] element (usually a [Button]): clicking it opens the
   dialog. Escape and clicking the backdrop close it. Focus is trapped
   inside the dialog while open via [x-trap.inert.noscroll], which
   requires the Alpine focus plugin — include [Ocelot.Alpine.script] in
   the page head. The dialog is server-rendered hidden ([x-cloak]) and
   only becomes interactive once Alpine loads. *)

let[@ocelot.htmx] createElement ?(class_ = "") ?(id : string option)
    ?(attrs : JSX.attribute list = []) ~title ~trigger ~content () =
  let modal_id =
    Option.value id ~default:(Alpine_util.derived_id "ocelot-modal-" title)
  in
  let trigger_wrapper =
    JSX.node "span"
      [
        ("class", `String "ocelot-modal__trigger");
        ("tabindex", `String "-1");
        ("@click", `String "open = true");
      ]
      [ trigger ]
  in
  let backdrop =
    JSX.node "div"
      [
        ("class", `String "ocelot-modal__backdrop");
        ("@click", `String "open = false");
      ]
      []
  in
  let title_el =
    JSX.node "h2"
      [
        ("id", `String (modal_id ^ "-title"));
        ("class", `String "ocelot-modal__title");
      ]
      [ JSX.string title ]
  in
  let close_btn =
    JSX.node "button"
      [
        ("class", `String "ocelot-modal__close");
        ("type", `String "button");
        ("aria-label", `String "Close dialog");
        ("@click", `String "open = false");
      ]
      [ JSX.string "✕" ]
  in
  let header =
    JSX.node "div"
      [ ("class", `String "ocelot-modal__header") ]
      [ title_el; close_btn ]
  in
  let content_div =
    JSX.node "div"
      [ ("class", `String "ocelot-modal__content") ]
      [ header; content ]
  in
  let modal =
    JSX.node "div"
      [
        ("class", `String (Html_util.class_value [ "ocelot-modal"; class_ ]));
        ("role", `String "dialog");
        ("aria-modal", `String "true");
        ("aria-labelledby", `String (modal_id ^ "-title"));
        ("x-show", `String "open");
        ("x-trap.inert.noscroll", `String "open");
        ("x-cloak", `Bool true);
        ("@keydown.escape.window", `String "open = false");
      ]
      [ backdrop; content_div ]
  in
  JSX.node "div"
    (("x-data", `String "{ open: false }") :: attrs)
    [ trigger_wrapper; modal ]

let make = createElement
