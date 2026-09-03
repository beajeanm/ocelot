(* Button component. *)

type variant = Primary | Secondary | Ghost | Danger
type size = Sm | Md | Lg

let variant_to_string = function
  | Primary -> "ocelot-button--primary"
  | Secondary -> "ocelot-button--secondary"
  | Ghost -> "ocelot-button--ghost"
  | Danger -> "ocelot-button--danger"

let size_to_string = function
  | Sm -> "ocelot-button--sm"
  | Md -> "ocelot-button--md"
  | Lg -> "ocelot-button--lg"

let createElement ?(variant = Primary) ?(size = Md) ?(disabled = false) ?type_
    ?(aria_label : string option) ?(class_ = "") ?(children = JSX.null) () =
  let classes =
    ref
      [
        "ocelot-button"; variant_to_string variant; size_to_string size; class_;
      ]
  in
  let class_str = Html_util.class_value !classes in
  let attrs = [ ("class", `String class_str) ] in
  let attrs = if disabled then ("disabled", `Bool true) :: attrs else attrs in
  let attrs =
    match type_ with Some t -> ("type", `String t) :: attrs | None -> attrs
  in
  let attrs =
    match aria_label with
    | Some l -> ("aria-label", `String l) :: attrs
    | None -> attrs
  in
  JSX.node "button" attrs [ children ]

let make = createElement
