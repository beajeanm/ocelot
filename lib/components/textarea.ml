(* Textarea component. *)

let createElement ?name ?(rows = 4) ?placeholder ?(disabled = false)
    ?(required = false) ?(readonly = false) ?id ?(class_ = "")
    ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-textarea"; class_ ] in
  let attrs = ref [ ("class", `String class_str); ("rows", `Int rows) ] in
  Option.iter (fun n -> attrs := ("name", `String n) :: !attrs) name;
  Option.iter
    (fun p -> attrs := ("placeholder", `String p) :: !attrs)
    placeholder;
  if disabled then attrs := ("disabled", `Bool true) :: !attrs;
  if required then attrs := ("required", `Bool true) :: !attrs;
  if readonly then attrs := ("readonly", `Bool true) :: !attrs;
  Option.iter (fun i -> attrs := ("id", `String i) :: !attrs) id;
  JSX.node "textarea" (List.rev !attrs) [ children ]

let make = createElement
