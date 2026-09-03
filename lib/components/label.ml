(* Label component. *)

let createElement ?(for_ : string option) ?(class_ = "") ?(children = JSX.null)
    () =
  let class_str = Html_util.class_value [ "ocelot-label"; class_ ] in
  let attrs = ref [ ("class", `String class_str) ] in
  Option.iter (fun f -> attrs := ("for", `String f) :: !attrs) for_;
  JSX.node "label" (List.rev !attrs) [ children ]

let make = createElement
