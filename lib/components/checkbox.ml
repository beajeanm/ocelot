(* Checkbox — a native [input type="checkbox"] with a custom, themeable
    visual. No JavaScript required: the real input is visually hidden but
    stays focusable and clickable (the wrapping [label] forwards clicks),
    so keyboard and screen-reader behaviour are native. *)

let createElement ?name ?value ?(checked = false) ?(disabled = false)
    ?(required = false) ?id ?(class_ = "") ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-checkbox"; class_ ] in
  let attrs = ("class", `String "ocelot-checkbox__input") :: attrs in
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
  let input = JSX.node "input" (("type", `String "checkbox") :: attrs) [] in
  let box =
    JSX.node "span"
      [
        ("class", `String "ocelot-checkbox__box");
        ("aria-hidden", `String "true");
      ]
      [ JSX.node "span" [ ("class", `String "ocelot-checkbox__indicator") ] [] ]
  in
  let children =
    if Html_util.is_null_element children then [ input; box ]
    else
      [
        input;
        box;
        JSX.node "span"
          [ ("class", `String "ocelot-checkbox__label") ]
          [ children ];
      ]
  in
  JSX.node "label" (("class", `String class_str) :: attrs) children

let make = createElement
