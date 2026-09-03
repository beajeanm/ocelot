(* Switch — a control that toggles between checked and not checked,
    presented as a sliding track-and-thumb. Built on a native
    [input type="checkbox"] with [role="switch"], so it works without
    JavaScript: clicking the label or pressing Space toggles it, and the
    value submits like any checkbox. *)

let createElement ?name ?value ?(checked = false) ?(disabled = false)
    ?(required = false) ?id ?(class_ = "") ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-switch"; class_ ] in
  let attrs = ref [ ("class", `String "ocelot-switch__input") ] in
  Option.iter (fun n -> attrs := ("name", `String n) :: !attrs) name;
  Option.iter (fun v -> attrs := ("value", `String v) :: !attrs) value;
  Option.iter (fun i -> attrs := ("id", `String i) :: !attrs) id;
  if checked then attrs := ("checked", `Bool true) :: !attrs;
  if disabled then attrs := ("disabled", `Bool true) :: !attrs;
  if required then attrs := ("required", `Bool true) :: !attrs;
  let input =
    JSX.node "input"
      (("type", `String "checkbox")
      :: ("role", `String "switch")
      :: List.rev !attrs)
      []
  in
  let track =
    JSX.node "span"
      [
        ("class", `String "ocelot-switch__track");
        ("aria-hidden", `String "true");
      ]
      [ JSX.node "span" [ ("class", `String "ocelot-switch__thumb") ] [] ]
  in
  let children =
    if Html_util.is_null_element children then [ input; track ]
    else
      [
        input;
        track;
        JSX.node "span"
          [ ("class", `String "ocelot-switch__label") ]
          [ children ];
      ]
  in
  JSX.node "label" [ ("class", `String class_str) ] children

let make = createElement
