(* Table component — submodules omit the class attribute when empty so the
   rendered markup stays clean. *)

let class_attrs class_ =
  if class_ = "" then [] else [ ("class", `String class_) ]

module Row = struct
  let[@ocelot.htmx] createElement ?(class_ = "")
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    JSX.node "tr" (class_attrs class_ @ attrs) [ children ]

  let make = createElement
end

module HeaderCell = struct
  let[@ocelot.htmx] createElement ?(scope = "col") ?(class_ = "")
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    JSX.node "th"
      ((("scope", `String scope) :: class_attrs class_) @ attrs)
      [ children ]

  let make = createElement
end

module Cell = struct
  let[@ocelot.htmx] createElement ?(class_ = "")
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    JSX.node "td" (class_attrs class_ @ attrs) [ children ]

  let make = createElement
end

module Head = struct
  let[@ocelot.htmx] createElement ?(class_ = "")
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    JSX.node "thead" (class_attrs class_ @ attrs) [ children ]

  let make = createElement
end

module Body = struct
  let[@ocelot.htmx] createElement ?(class_ = "")
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    JSX.node "tbody" (class_attrs class_ @ attrs) [ children ]

  let make = createElement
end

let[@ocelot.htmx] createElement ?(class_ = "")
    ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
  let wrapper_class =
    Html_util.class_value [ "ocelot-table-wrapper"; class_ ]
  in
  let table =
    JSX.node "table" [ ("class", `String "ocelot-table") ] [ children ]
  in
  JSX.node "div" (("class", `String wrapper_class) :: attrs) [ table ]

let make = createElement
