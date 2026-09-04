(* Radio Group — a set of mutually exclusive options from which exactly
    one can be selected. Built on native [input type="radio"] buttons, so
    arrow-key navigation, selection, and screen-reader announcements all
    come for free — no JavaScript required.

    Pass [Item]s (one radio + its label) as children. Give every item the
    same [name] to make the group mutually exclusive; [disabled] on the
    group disables all descendant controls natively via the [fieldset]. *)

module Item = struct
  (* A single radio option with a custom, themeable visual. *)

  let[@ocelot.htmx] createElement ?name ?value ?(checked = false)
      ?(disabled = false) ?(required = false) ?id ?(class_ = "")
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    let class_str = Html_util.class_value [ "ocelot-radio"; class_ ] in
    let attrs = ("class", `String "ocelot-radio__input") :: attrs in
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
    let input = JSX.node "input" (("type", `String "radio") :: attrs) [] in
    let circle =
      JSX.node "span"
        [
          ("class", `String "ocelot-radio__circle");
          ("aria-hidden", `String "true");
        ]
        [ JSX.node "span" [ ("class", `String "ocelot-radio__dot") ] [] ]
    in
    let children =
      if Html_util.is_null_element children then [ input; circle ]
      else
        [
          input;
          circle;
          JSX.node "span"
            [ ("class", `String "ocelot-radio__label") ]
            [ children ];
        ]
    in
    JSX.node "label" [ ("class", `String class_str) ] children

  let make = createElement
end

(* The group wrapper: a [fieldset role="radiogroup"] with an optional
    visible legend ([label]) or an accessible name only ([aria_label]). *)

let[@ocelot.htmx] createElement ?(label : string option)
    ?(aria_label : string option) ?(disabled = false) ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-radio-group"; class_ ] in
  let accessible_name =
    match label with Some l -> Some l | None -> aria_label
  in
  let attrs =
    ("class", `String class_str) :: ("role", `String "radiogroup") :: attrs
  in
  let attrs =
    match accessible_name with
    | Some n -> ("aria-label", `String n) :: attrs
    | None -> attrs
  in
  let attrs = if disabled then ("disabled", `Bool true) :: attrs else attrs in
  let legend =
    match label with
    | Some l ->
        Some
          (JSX.node "legend"
             [ ("class", `String "ocelot-radio-group__legend") ]
             [ JSX.string l ])
    | None -> None
  in
  let children =
    match legend with Some lg -> JSX.list [ lg; children ] | None -> children
  in
  JSX.node "fieldset" attrs [ children ]

let make = createElement
