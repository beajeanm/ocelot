(* Toast / Notification — driven by Alpine.js.

   Renders with [role="status"] and [aria-live="polite"] so screen readers
   announce it. With [duration] > 0 (the default, milliseconds) it
   auto-dismisses; a dismiss button is always rendered. Place toasts inside
   [Container], which positions them fixed in the bottom-right corner. *)

type variant = Success | Warning | Danger | Info

let variant_to_string (v : variant) =
  match v with
  | Success -> "ocelot-alert--success"
  | Warning -> "ocelot-alert--warning"
  | Danger -> "ocelot-alert--danger"
  | Info -> "ocelot-alert--info"

let[@ocelot.htmx] createElement ?(variant = Info) ?(class_ = "")
    ?(duration = 5000) ?(attrs : JSX.attribute list = []) ?(children = JSX.null)
    () =
  let class_str =
    Html_util.class_value
      [ "ocelot-alert ocelot-toast"; variant_to_string variant; class_ ]
  in
  let dismiss =
    JSX.node "button"
      [
        ("class", `String "ocelot-toast__dismiss");
        ("type", `String "button");
        ("aria-label", `String "Dismiss notification");
        ("@click", `String "visible = false");
      ]
      [ JSX.string "✕" ]
  in
  let root_attrs =
    [
      ("class", `String class_str);
      ("role", `String "status");
      ("aria-live", `String "polite");
      ("x-data", `String "{ visible: true }");
      ("x-show", `String "visible");
      ("x-transition.opacity", `Bool true);
    ]
  in
  let root_attrs =
    if duration > 0 then
      ( "x-init",
        `String
          (Printf.sprintf "setTimeout(() => visible = false, %d)" duration) )
      :: root_attrs
    else root_attrs
  in
  JSX.node "div" (root_attrs @ attrs) [ children; dismiss ]

let make = createElement

module Container = struct
  let[@ocelot.htmx] createElement ?(class_ = "")
      ?(attrs : JSX.attribute list = []) ?(children = JSX.null) () =
    let class_str =
      Html_util.class_value [ "ocelot-toast-container"; class_ ]
    in
    JSX.node "div"
      (("class", `String class_str)
      :: ("role", `String "region")
      :: ("aria-label", `String "Notifications")
      :: attrs)
      [ children ]

  let make = createElement
end
