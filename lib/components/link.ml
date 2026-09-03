(* Link component. *)

type variant = Default | Muted

let variant_to_string = function Default -> "" | Muted -> "ocelot-link--muted"

let createElement ~href ?(variant = Default) ?(external_ = false) ?(class_ = "")
    ?(children = JSX.null) () =
  let classes = ref [ "ocelot-link"; variant_to_string variant; class_ ] in
  let class_str = Html_util.class_value !classes in
  let attrs = [ ("class", `String class_str); ("href", `String href) ] in
  let attrs =
    if external_ then
      ("rel", `String "noopener noreferrer")
      :: ("target", `String "_blank")
      :: attrs
    else attrs
  in
  JSX.node "a" attrs [ children ]

let make = createElement
