(* Checkbox — a native [input type="checkbox"] with a custom, themeable
    visual. No JavaScript required: the real input is visually hidden but
    stays focusable and clickable (the wrapping [label] forwards clicks),
    so keyboard and screen-reader behaviour are native. *)

let createElement ?name ?value ?(checked = false) ?(disabled = false)
    ?(required = false) ?id ?(class_ = "") ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-checkbox"; class_ ] in
  let attrs = ref [ ("class", `String "ocelot-checkbox__input") ] in
  Option.iter (fun n -> attrs := ("name", `String n) :: !attrs) name;
  Option.iter (fun v -> attrs := ("value", `String v) :: !attrs) value;
  Option.iter (fun i -> attrs := ("id", `String i) :: !attrs) id;
  if checked then attrs := ("checked", `Bool true) :: !attrs;
  if disabled then attrs := ("disabled", `Bool true) :: !attrs;
  if required then attrs := ("required", `Bool true) :: !attrs;
  let input =
    JSX.node "input" (("type", `String "checkbox") :: List.rev !attrs) []
  in
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
  JSX.node "label" [ ("class", `String class_str) ] children

let make = createElement
