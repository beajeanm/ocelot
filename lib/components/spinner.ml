(* Spinner — an animated indicator for loading states. Pure CSS (a
    rotating partial ring); announced politely to screen readers via
    [role="status"]. [children], if given, renders as visible text next
    to the spinner (and doubles as the accessible label). *)

type size = Sm | Md | Lg

let size_to_string = function
  | Sm -> "ocelot-spinner--sm"
  | Md -> "ocelot-spinner--md"
  | Lg -> "ocelot-spinner--lg"

let createElement ?(size = Md) ?(aria_label : string option) ?(class_ = "")
    ?(children = JSX.null) () =
  let class_str =
    Html_util.class_value [ "ocelot-spinner"; size_to_string size; class_ ]
  in
  (* role="status" announces the element's content politely, so visible
     label text needs no extra aria-label; bare spinners get one so screen
     readers announce something meaningful. *)
  let attrs =
    ref [ ("class", `String class_str); ("role", `String "status") ]
  in
  (match (aria_label, children) with
  | Some label, _ -> attrs := ("aria-label", `String label) :: !attrs
  | None, children when Html_util.is_null_element children ->
      attrs := ("aria-label", `String "Loading") :: !attrs
  | None, _ -> ());
  let spinner =
    JSX.node "span"
      [
        ("class", `String "ocelot-spinner__icon");
        ("aria-hidden", `String "true");
      ]
      []
  in
  if Html_util.is_null_element children then
    JSX.node "span" (List.rev !attrs) [ spinner ]
  else
    let content =
      JSX.list
        [
          spinner;
          JSX.node "span"
            [ ("class", `String "ocelot-spinner__label") ]
            [ children ];
        ]
    in
    JSX.node "span" (List.rev !attrs) [ content ]

let make = createElement
