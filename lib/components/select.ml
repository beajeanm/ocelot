(* Native Select component — accessible by default, no JavaScript required.

    For a custom styled dropdown with Alpine.js keyboard navigation, see
    [Dropdown]. *)

type option_item = { value : string; label : string; disabled : bool }

let createElement ?name ?id ?(disabled = false) ?(required = false)
    ?(multiple = false) ?(class_ = "") ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) ~options () =
  let class_str = Html_util.class_value [ "ocelot-input"; class_ ] in
  let attrs = ("class", `String class_str) :: attrs in
  let attrs =
    match name with Some n -> ("name", `String n) :: attrs | None -> attrs
  in
  let attrs =
    match id with Some i -> ("id", `String i) :: attrs | None -> attrs
  in
  let attrs = if disabled then ("disabled", `Bool true) :: attrs else attrs in
  let attrs = if required then ("required", `Bool true) :: attrs else attrs in
  let attrs = if multiple then ("multiple", `Bool true) :: attrs else attrs in
  let option_els =
    List.map
      (fun (opt : option_item) ->
        let opt_attrs = [ ("value", `String opt.value) ] in
        let opt_attrs =
          if opt.disabled then ("disabled", `Bool true) :: opt_attrs
          else opt_attrs
        in
        JSX.node "option" opt_attrs [ JSX.string opt.label ])
      options
  in
  ignore children;
  JSX.node "select" attrs option_els

let make = createElement
