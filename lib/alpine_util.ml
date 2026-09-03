(* Internal helpers for building Alpine.js expressions embedded in
   attribute values.

   JSX escapes attribute values (including [&] and [']), which browsers
   decode when parsing, so the expressions below survive rendering
   verbatim. Avoid [<] in expressions since it would break the HTML. *)

(** Escape a string for use inside a single-quoted JavaScript string. *)
let escape_sq s =
  let buf = Buffer.create (String.length s + 8) in
  String.iter
    (fun c ->
      match c with
      | '\'' -> Buffer.add_string buf "\\'"
      | '\\' -> Buffer.add_string buf "\\\\"
      | '\n' -> Buffer.add_string buf "\\n"
      | '\r' -> Buffer.add_string buf "\\r"
      | c when Char.code c < 0x20 ->
          Buffer.add_string buf (Printf.sprintf "\\u%04x" (Char.code c))
      | c -> Buffer.add_char buf c)
    s;
  Buffer.contents buf

(** A short, stable, unique-looking id derived from a seed string. *)
let derived_id prefix seed = prefix ^ string_of_int (Hashtbl.hash seed)
