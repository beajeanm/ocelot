(* Radio Group — a set of mutually exclusive options from which exactly
    one can be selected. Built on native [input type="radio"] buttons, so
    arrow-key navigation, selection, and screen-reader announcements all
    come for free — no JavaScript required.

    Pass [Item]s (one radio + its label) as children. Give every item the
    same [name] to make the group mutually exclusive; [disabled] on the
    group disables all descendant controls natively via the [fieldset]. *)

module Item = struct
  (* A single radio option with a custom, themeable visual. *)

  let createElement ?name ?value ?(checked = false) ?(disabled = false)
      ?(required = false) ?id ?(class_ = "") ?(children = JSX.null) () =
    let class_str = Html_util.class_value [ "ocelot-radio"; class_ ] in
    let attrs = ref [ ("class", `String "ocelot-radio__input") ] in
    Option.iter (fun n -> attrs := ("name", `String n) :: !attrs) name;
    Option.iter (fun v -> attrs := ("value", `String v) :: !attrs) value;
    Option.iter (fun i -> attrs := ("id", `String i) :: !attrs) id;
    if checked then attrs := ("checked", `Bool true) :: !attrs;
    if disabled then attrs := ("disabled", `Bool true) :: !attrs;
    if required then attrs := ("required", `Bool true) :: !attrs;
    let input =
      JSX.node "input" (("type", `String "radio") :: List.rev !attrs) []
    in
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

let createElement ?(label : string option) ?(aria_label : string option)
    ?(disabled = false) ?(class_ = "") ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-radio-group"; class_ ] in
  let accessible_name =
    match label with Some l -> Some l | None -> aria_label
  in
  let attrs =
    ref [ ("class", `String class_str); ("role", `String "radiogroup") ]
  in
  Option.iter
    (fun n -> attrs := ("aria-label", `String n) :: !attrs)
    accessible_name;
  if disabled then attrs := ("disabled", `Bool true) :: !attrs;
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
  JSX.node "fieldset" (List.rev !attrs) [ children ]

let make = createElement
