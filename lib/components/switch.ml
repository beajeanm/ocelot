(* Switch — a control that toggles between checked and not checked,
    presented as a sliding track-and-thumb. Built on a native
    [input type="checkbox"] with [role="switch"], so it works without
    JavaScript: clicking the label or pressing Space toggles it, and the
    value submits like any checkbox. *)

let[@ocelot.htmx] createElement ?name ?value ?(checked = false)
    ?(disabled = false) ?(required = false) ?id ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-switch"; class_ ] in
  let attrs = ("class", `String "ocelot-switch__input") :: attrs in
  let attrs =
    match name with Some n -> ("name", `String n) :: attrs | None -> attrs
  in
  let attrs =
    match value with Some v -> ("value", `String v) :: attrs | None -> attrs
  in
  let attrs =
    match id with Some i -> ("id", `String i) :: attrs | None -> attrs
  in
  let attrs = if checked then ("checked", `Bool true) :: attrs else attrs in
  let attrs = if disabled then ("disabled", `Bool true) :: attrs else attrs in
  let attrs = if required then ("required", `Bool true) :: attrs else attrs in
  let input =
    JSX.node "input"
      (("type", `String "checkbox") :: ("role", `String "switch") :: attrs)
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
