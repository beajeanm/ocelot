(* Table component — submodules omit the class attribute when empty so the
   rendered markup stays clean. *)

let class_attrs class_ =
  if class_ = "" then [] else [ ("class", `String class_) ]

module Row = struct
  let createElement ?(class_ = "") ?(children = JSX.null) () =
    JSX.node "tr" (class_attrs class_) [ children ]

  let make = createElement
end

module HeaderCell = struct
  let createElement ?(scope = "col") ?(class_ = "") ?(children = JSX.null) () =
    JSX.node "th" (("scope", `String scope) :: class_attrs class_) [ children ]

  let make = createElement
end

module Cell = struct
  let createElement ?(class_ = "") ?(children = JSX.null) () =
    JSX.node "td" (class_attrs class_) [ children ]

  let make = createElement
end

module Head = struct
  let createElement ?(class_ = "") ?(children = JSX.null) () =
    JSX.node "thead" (class_attrs class_) [ children ]

  let make = createElement
end

module Body = struct
  let createElement ?(class_ = "") ?(children = JSX.null) () =
    JSX.node "tbody" (class_attrs class_) [ children ]

  let make = createElement
end

let createElement ?(class_ = "") ?(children = JSX.null) () =
  let wrapper_class =
    Html_util.class_value [ "ocelot-table-wrapper"; class_ ]
  in
  let table =
    JSX.node "table" [ ("class", `String "ocelot-table") ] [ children ]
  in
  JSX.node "div" [ ("class", `String wrapper_class) ] [ table ]

let make = createElement
