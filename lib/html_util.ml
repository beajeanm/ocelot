(* Utilities for building HTML attribute values. *)

(** Build a class attribute value from a list of class names, skipping empty
    ones so no stray spaces appear in the rendered markup. *)
let class_value parts =
  parts |> List.filter (fun s -> s <> "") |> String.concat " "
