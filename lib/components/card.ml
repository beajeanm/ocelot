(* Card component. *)

type shadow = Sm | Md | Lg

let shadow_to_string = function
  | Sm -> "ocelot-card--shadow-sm"
  | Md -> "ocelot-card--shadow-md"
  | Lg -> "ocelot-card--shadow-lg"

let createElement ?shadow ?(class_ = "") ?(children = JSX.null) () =
  let classes = ref [ "ocelot-card"; class_ ] in
  Option.iter (fun s -> classes := shadow_to_string s :: !classes) shadow;
  let class_str = Html_util.class_value !classes in
  JSX.node "div" [ ("class", `String class_str) ] [ children ]

module Header = struct
  let createElement ?(class_ = "") ?(children = JSX.null) () =
    let class_str = Html_util.class_value [ "ocelot-card__header"; class_ ] in
    JSX.node "div" [ ("class", `String class_str) ] [ children ]

  let make = createElement
end

module Body = struct
  let createElement ?(class_ = "") ?(children = JSX.null) () =
    let class_str = Html_util.class_value [ "ocelot-card__body"; class_ ] in
    JSX.node "div" [ ("class", `String class_str) ] [ children ]

  let make = createElement
end

module Footer = struct
  let createElement ?(class_ = "") ?(children = JSX.null) () =
    let class_str = Html_util.class_value [ "ocelot-card__footer"; class_ ] in
    JSX.node "div" [ ("class", `String class_str) ] [ children ]

  let make = createElement
end

let make = createElement
