(* Text — typography primitive. *)

type size = Sm | Md | Lg | Xl
type weight = Normal | Medium | Semibold | Bold
type align = Left | Center | Right

type color =
  | Primary
  | Secondary
  | Heading
  | Muted
  | Primary_accent
  | Danger
  | Success
  | Warning
  | Info

let size_to_string = function
  | Sm -> "ocelot-text--sm"
  | Md -> "ocelot-text--md"
  | Lg -> "ocelot-text--lg"
  | Xl -> "ocelot-text--xl"

let weight_to_string = function
  | Normal -> "ocelot-text--weight-normal"
  | Medium -> "ocelot-text--weight-medium"
  | Semibold -> "ocelot-text--weight-semibold"
  | Bold -> "ocelot-text--weight-bold"

let align_to_string = function
  | Left -> "ocelot-text--align-left"
  | Center -> "ocelot-text--align-center"
  | Right -> "ocelot-text--align-right"

let color_to_string = function
  | Primary -> "ocelot-text--color-primary"
  | Secondary -> "ocelot-text--color-secondary"
  | Heading -> "ocelot-text--color-heading"
  | Muted -> "ocelot-text--color-muted"
  | Primary_accent -> "ocelot-text--color-primary-accent"
  | Danger -> "ocelot-text--color-danger"
  | Success -> "ocelot-text--color-success"
  | Warning -> "ocelot-text--color-warning"
  | Info -> "ocelot-text--color-info"

let createElement ?(tag = "p") ?size ?weight ?align ?color ?(class_ = "")
    ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) () =
  let classes = ref [ "ocelot-text"; class_ ] in
  Option.iter (fun s -> classes := size_to_string s :: !classes) size;
  Option.iter (fun w -> classes := weight_to_string w :: !classes) weight;
  Option.iter (fun a -> classes := align_to_string a :: !classes) align;
  Option.iter (fun c -> classes := color_to_string c :: !classes) color;
  let class_str = Html_util.class_value !classes in
  JSX.node tag (("class", `String class_str) :: attrs) [ children ]

let make = createElement
