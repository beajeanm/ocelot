(* CSS rendering — produces a single <style> tag with all theme variables
   and component styles. *)

let render () =
  let css = Styles.all ~light:Theme.default_light ~dark:Theme.default_dark in
  JSX.unsafe (Printf.sprintf "<style>%s</style>" css)

let render_with_themes ~(light : Theme.t) ~(dark : Theme.t) () =
  let css = Styles.all ~light ~dark in
  JSX.unsafe (Printf.sprintf "<style>%s</style>" css)
