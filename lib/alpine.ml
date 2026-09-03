(* Alpine.js script helper.

   Ocelot's interactive components (Tabs, Accordion, Modal, Toast, Tooltip,
   Dropdown) use [Alpine.js] for lightweight client-side behavior. Include
   this helper once in the page [<head]:

   {[
     (Ocelot.Alpine.script ())
   ]}

   It loads the Alpine focus plugin (required by [Modal] for [x-trap] focus
   trapping) and Alpine core, both deferred, from jsDelivr. The focus plugin
   must be loaded before core Alpine. Pass ~version to pin a specific
   release. *)

let script ?(version = "3.x.x") () =
  Printf.sprintf
    {|<script defer src="https://cdn.jsdelivr.net/npm/@alpinejs/focus@%s/dist/cdn.min.js"></script>
<script defer src="https://cdn.jsdelivr.net/npm/alpinejs@%s/dist/cdn.min.js"></script>|}
    version version
  |> JSX.unsafe
