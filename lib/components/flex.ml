(* Flex — horizontal/vertical flex container.

    The [align]/[justify] constructors share names, so the conversion
    functions are annotated to avoid OCaml's constructor-ambiguity
    resolution picking the wrong variant type. *)

type gap = G0 | G1 | G2 | G3 | G4 | G5 | G6 | G8
type direction = Row | Column
type align = Start | Center | End
type justify = Start | Center | End | Between

let gap_to_string (g : gap) =
  match g with
  | G0 -> "ocelot-flex--gap-0"
  | G1 -> "ocelot-flex--gap-1"
  | G2 -> "ocelot-flex--gap-2"
  | G3 -> "ocelot-flex--gap-3"
  | G4 -> "ocelot-flex--gap-4"
  | G5 -> "ocelot-flex--gap-5"
  | G6 -> "ocelot-flex--gap-6"
  | G8 -> "ocelot-flex--gap-8"

let direction_to_string (d : direction) =
  match d with Row -> "ocelot-flex--row" | Column -> "ocelot-flex--column"

let align_to_string (a : align) =
  match a with
  | Start -> "ocelot-flex--align-start"
  | Center -> "ocelot-flex--align-center"
  | End -> "ocelot-flex--align-end"

let justify_to_string (j : justify) =
  match j with
  | Start -> "ocelot-flex--justify-start"
  | Center -> "ocelot-flex--justify-center"
  | End -> "ocelot-flex--justify-end"
  | Between -> "ocelot-flex--justify-between"

let[@ocelot.htmx] createElement ?(direction = Row) ?gap ?align ?justify
    ?(class_ = "") ?(attrs : JSX.attribute list = []) ?(children = JSX.null) ()
    =
  let classes = ref [ "ocelot-flex"; direction_to_string direction; class_ ] in
  Option.iter (fun g -> classes := gap_to_string g :: !classes) gap;
  Option.iter (fun a -> classes := align_to_string a :: !classes) align;
  Option.iter (fun j -> classes := justify_to_string j :: !classes) justify;
  let class_str = Html_util.class_value !classes in
  JSX.node "div" (("class", `String class_str) :: attrs) [ children ]

let make = createElement
