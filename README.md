# Ocelot

Themable, accessible UI components for **server-side HTML** in OCaml.

Ocelot is a library of UI components — buttons, forms, tables, cards, modals,
tabs, and more — that render to plain HTML strings on the server. It is built
on [html_of_jsx](https://github.com/davesnx/html_of_jsx) and works great with
the [mlx](https://github.com/ocaml-mlx/mlx) JSX syntax dialect, but it is
plain OCaml underneath: no build step, no client-side framework, no CSS
pipeline.

## Highlights

- **Server-rendered** — components produce HTML strings; no JavaScript is
  required for the core set (forms, tables, badges, alerts, pagination,
  breadcrumbs, links…).
- **Accessible by default** — semantic markup, ARIA attributes, keyboard
  support (roving tabindex tabs, focus-trapped modals, listbox dropdowns).
- **Themeable** — a full design-token system (colors, typography, spacing,
  shadows) built on CSS custom properties. Light and dark themes ship by
  default; switch at runtime by toggling a `data-ocelot-theme` attribute.
- **Progressive enhancement** — the few interactive components (tabs,
  accordions, modals, dropdowns, tooltips, toasts) are driven by
  [Alpine.js](https://alpinejs.dev) (~15 kb), loaded from a CDN with one
  function call. Their server-rendered markup is correct even before (or
  without) JavaScript.
- **Zero CSS build step** — all component styles are embedded in the library
  and emitted as a single `<style>` tag.

## Installation

Ocelot is not yet on opam. For now, pin it from this repository:

```sh
opam pin add ocelot .
```

Dependencies: `ocaml` ≥ 5.0, `dune` ≥ 3.24, and `html_of_jsx` (runtime).
The mlx dialect is **not** a dependency of the library — you only need it if
you want to author your pages in JSX syntax (as in the examples below).

## Quick start (mlx syntax)

Set up a dune project with the mlx dialect and `html_of_jsx`:

```lisp
;; dune-project
(lang dune 3.24)

(depends html_of_jsx mlx)

(dialect
 (name mlx)
 (implementation
  (extension mlx)
  (merlin_reader mlx)
  (preprocess
   (run mlx-pp %{input-file}))))
```

```lisp
;; dune
(executable
 (name my_page)
 (libraries ocelot html_of_jsx)
 (preprocess (pps html_of_jsx.ppx)))
```

Then render a page:

```ocaml
(* my_page.mlx *)
let page =
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <title>"My app"</title>
      (Ocelot.Css.render ())
      (Ocelot.Alpine.script ())
    </head>
    <body>
      <Ocelot.Stack gap=G4>
        <Ocelot.Text tag="h1" weight=Text.Bold color=Text.Heading>"Welcome"</Ocelot.Text>
        <Ocelot.Input type_="email" name="email" placeholder="you@example.com" />
        <Ocelot.Button variant=Primary>"Sign up"</Ocelot.Button>
      </Ocelot.Stack>
    </body>
  </html>

let () = print_endline (JSX.render page)
```

Run it with `dune exec ./my_page.exe`. Two lines do the wiring:

- `Ocelot.Css.render ()` emits a `<style>` tag with all theme variables and
  component styles.
- `Ocelot.Alpine.script ()` loads Alpine.js (plus the focus plugin) from the
  CDN. Only needed if your page uses interactive components.

## Plain OCaml, no syntax extensions

The mlx/ppx toolchain is entirely optional. Ocelot is a plain library, and
every component is just a function returning a `JSX.element`:

```ocaml
let signup_form =
  Ocelot.Stack.createElement ~gap:Ocelot.Stack.G4
    ~children:
      (JSX.list
         [ Ocelot.Input.createElement ~type_:"email" ~name:"email" ();
           Ocelot.Button.createElement ~variant:Ocelot.Button.Primary
             ~children:(JSX.string "Sign up") () ])
    ()
```

Use `JSX.render` to turn the result into an HTML string (or
`JSX.render_streaming` / `JSX.render_to_channel` for streaming responses).

## Theming

Themes are OCaml records of design tokens (`Ocelot.Theme.t`), compiled to CSS
custom properties. Both light and dark themes are included:

```ocaml
Ocelot.Css.render ()                (* default light + dark themes *)
Ocelot.Css.render_with_themes ~light:my_light ~dark:my_dark ()
```

The active theme is selected with the `data-ocelot-theme` attribute — set it
on `<html>` (or any ancestor of the components). A minimal client-side toggle:

```js
document.documentElement.setAttribute("data-ocelot-theme", "dark");
```

To create your own theme, start from a record and override tokens:

```ocaml
open Ocelot

let my_light =
  { Theme.default_light with
    primary = "oklch(55% 0.16 140)";
    primary_hover = "oklch(48% 0.16 140)" }
```

Tokens cover colors, fonts, font sizes, spacing, radii, shadows, focus rings,
and disabled opacity.

## Components

| Component | Notes |
| --- | --- |
| `Box` | Layout primitive (padding, margin, border, radius, shadow) |
| `Stack`, `Flex` | Vertical / horizontal layout with gap, align, justify |
| `Text`, `Divider` | Typography (size, weight, align, color) and separators |
| `Button`, `Link` | Variants: primary, secondary, ghost, danger |
| `Input`, `Textarea`, `Label`, `Select`, `Dropdown` | Forms — `Select` is native (no JS), `Dropdown` is an Alpine-powered listbox |
| `Checkbox`, `Radio_group`, `Switch` | Toggles and exclusive choices — native inputs with custom styling, no JS |
| `Progress`, `Spinner` | Task completion bar and loading indicator — pure CSS animation |
| `Calendar` | Month grid of day buttons; selected/today/disabled days, prev/next via server round-trips |
| `Badge`, `Alert` | Status indicators and messages |
| `Card` | Composable: `Card.Header`, `Card.Body`, `Card.Footer` |
| `Table` | `Head`, `Body`, `Row`, `HeaderCell`, `Cell` |
| `Tabs`, `Accordion` | Alpine-driven; correct initial markup without JS |
| `Modal` | Focus-trapped dialog (requires `Ocelot.Alpine.script`) |
| `Tooltip` | Hover + keyboard focus, positioned via `aria-describedby` |
| `Toast` | Self-dismissing notifications (`Toast.Container` + `Toast`) |
| `Pagination`, `Breadcrumb` | Navigation, with current/disabled states |
| `Scroll area` | Overflowing content with thin, themeable scrollbars |

Components are modules (`Ocelot.Button`, `Ocelot.Table.Row`, …), each with a
`createElement` (aliased as `make`) whose optional labeled arguments match the
JSX props. In mlx, `<Ocelot.Button variant=Danger>"Delete"</Ocelot.Button>`
desugars to `Ocelot.Button.createElement ~variant:Danger
~children:(JSX.string "Delete") ()`.

## Showcase

The [`examples/showcase`](examples/showcase/) renders a sample page exercising
every component in both themes:

```sh
opam install mlx          # only needed to build the showcase
dune exec --root examples/showcase ./showcase.exe > shadow.html
```

## License

MIT © Jean-Michel Bea
