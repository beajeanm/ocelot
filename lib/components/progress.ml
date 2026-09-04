(* Progress — a visual indicator of how far a task has advanced toward
    completion. Pure CSS: a track plus an indicator bar sized by
    [aria-valuenow]. Set [indeterminate] for tasks of unknown length. *)

let[@ocelot.htmx] createElement ?(value = 0.0) ?(indeterminate = false)
    ?(aria_label : string option) ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
  ignore children;
  let value = Float.min 1.0 (Float.max 0.0 value) in
  let percent = int_of_float (Float.round (value *. 100.0)) in
  let class_str =
    Html_util.class_value
      ([
         "ocelot-progress";
         (if indeterminate then "ocelot-progress--indeterminate" else "");
         class_;
       ]
        : string list)
  in
  let root_attrs =
    ref [ ("class", `String class_str); ("role", `String "progressbar") ]
  in
  if not indeterminate then
    root_attrs :=
      ("aria-valuenow", `String (string_of_int percent)) :: !root_attrs;
  Option.iter
    (fun l -> root_attrs := ("aria-label", `String l) :: !root_attrs)
    aria_label;
  root_attrs :=
    ("aria-valuemin", `String "0")
    :: ("aria-valuemax", `String "100")
    :: !root_attrs;
  let indicator =
    let indicator_attrs =
      [ ("class", `String "ocelot-progress__indicator") ]
      @
      if indeterminate then []
      else [ ("style", `String (Printf.sprintf "width: %d%%" percent)) ]
    in
    JSX.node "div" indicator_attrs []
  in
  JSX.node "div" (List.rev !root_attrs @ attrs) [ indicator ]

let make = createElement
