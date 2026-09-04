(* Accordion — expand/collapse items driven by Alpine.js.

   Each item owns its [open] state: the trigger button toggles it,
   [aria-expanded] is kept in sync reactively, and the panel is toggled
   via the [hidden] attribute. The server-rendered markup reflects the
   initial [open_] state, so it is correct before Alpine loads and with
   JavaScript disabled. *)

module Item = struct
  let[@ocelot.htmx] createElement ?(open_ = false) ?(class_ = "")
      ?(id : string option) ?(attrs : JSX.attribute list = [])
      ?(children = JSX.null) ~title () =
    let item_id =
      Option.value id ~default:(Alpine_util.derived_id "ocelot-acc-" title)
    in
    let open_str = Bool.to_string open_ in
    let trigger =
      JSX.node "button"
        [
          ("class", `String "ocelot-accordion__trigger");
          ("type", `String "button");
          ("aria-expanded", `String open_str);
          (":aria-expanded", `String "open ? 'true' : 'false'");
          ("aria-controls", `String (item_id ^ "-panel"));
          ("@click", `String "open = !open");
        ]
        [
          JSX.string title;
          JSX.node "span"
            [
              ("class", `String "ocelot-accordion__icon");
              ("aria-hidden", `String "true");
            ]
            [ JSX.string "▼" ];
        ]
    in
    let panel_attrs =
      [
        ("class", `String "ocelot-accordion__panel");
        ("id", `String (item_id ^ "-panel"));
        (":hidden", `String "!open");
      ]
    in
    let panel_attrs =
      if open_ then panel_attrs else ("hidden", `Bool true) :: panel_attrs
    in
    let panel = JSX.node "div" panel_attrs [ children ] in
    let class_str =
      Html_util.class_value [ "ocelot-accordion__item"; class_ ]
    in
    JSX.node "div"
      (("class", `String class_str)
      :: ("x-data", `String (Printf.sprintf "{ open: %s }" open_str))
      :: attrs)
      [ trigger; panel ]

  let make = createElement
end

let createElement ?(class_ = "") ?(attrs : JSX.attribute list = [])
    ?(children = JSX.null) () =
  let class_str = Html_util.class_value [ "ocelot-accordion"; class_ ] in
  JSX.node "div" (("class", `String class_str) :: attrs) [ children ]

let make = createElement
