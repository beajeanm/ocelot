(lang dune 3.20)

(generate_opam_files true)

(implicit_transitive_deps false)

(name ocelot)

(maintainers "Jean-Michel Bea <code@jm-bea.net>")

(authors "Jean-Michel Bea <code@jm-bea.net>")

(license MIT)

(source
 (github beajeanm/ocelot))

(package
 (name ocelot)
 (synopsis "Themable UI components for server-side HTML in OCaml")
 (description
  "Ocelot is a library of beautifully-designed, accessible, and themeable UI components for generating server-side HTML using html_of_jsx.")
 (depends
  (ocaml
   (>= 5.0))
  (dune
   (>= 3.24))
  (html_of_jsx
   (>= 0.1.0))
  (alcotest :with-test)))
