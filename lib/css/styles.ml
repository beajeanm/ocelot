(* Embedded CSS for all Ocelot components.

   This module contains the complete stylesheet as an OCaml string.
   Users render it with [Ocelot.Css.render].

   Styles use CSS Custom Properties defined by the active theme.
   Light theme is the default (:root); dark theme overrides are
   scoped to [data-ocelot-theme="dark"]. *)

let base_reset =
  {|
*, *::before, *::after {
  box-sizing: border-box;
}

.ocelot-sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}

.ocelot-focus:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

/* Alpine.js: hide x-cloak elements until Alpine initializes, and respect
   the hidden attribute everywhere (used for no-JS tab/accordion states). */
[x-cloak] {
  display: none !important;
}

[hidden] {
  display: none !important;
}
|}

let theme_variables ~(light : Theme.t) ~(dark : Theme.t) =
  let light_css = Theme.theme_to_css light in
  let dark_css = Theme.theme_to_css dark in
  Printf.sprintf
    {|
:root, [data-ocelot-theme="light"] {
%s
}

[data-ocelot-theme="dark"] {
%s
}
|}
    light_css dark_css

let box_styles =
  {|
.ocelot-box {
  display: block;
}

.ocelot-box--padding-0  { padding: 0; }
.ocelot-box--padding-1  { padding: calc(var(--ocelot-spacing-unit) * 1); }
.ocelot-box--padding-2  { padding: calc(var(--ocelot-spacing-unit) * 2); }
.ocelot-box--padding-3  { padding: calc(var(--ocelot-spacing-unit) * 3); }
.ocelot-box--padding-4  { padding: calc(var(--ocelot-spacing-unit) * 4); }
.ocelot-box--padding-5  { padding: calc(var(--ocelot-spacing-unit) * 5); }
.ocelot-box--padding-6  { padding: calc(var(--ocelot-spacing-unit) * 6); }
.ocelot-box--padding-8  { padding: calc(var(--ocelot-spacing-unit) * 8); }
.ocelot-box--padding-10 { padding: calc(var(--ocelot-spacing-unit) * 10); }
.ocelot-box--padding-12 { padding: calc(var(--ocelot-spacing-unit) * 12); }

.ocelot-box--margin-0  { margin: 0; }
.ocelot-box--margin-1  { margin: calc(var(--ocelot-spacing-unit) * 1); }
.ocelot-box--margin-2  { margin: calc(var(--ocelot-spacing-unit) * 2); }
.ocelot-box--margin-3  { margin: calc(var(--ocelot-spacing-unit) * 3); }
.ocelot-box--margin-4  { margin: calc(var(--ocelot-spacing-unit) * 4); }
.ocelot-box--margin-5  { margin: calc(var(--ocelot-spacing-unit) * 5); }
.ocelot-box--margin-6  { margin: calc(var(--ocelot-spacing-unit) * 6); }
.ocelot-box--margin-8  { margin: calc(var(--ocelot-spacing-unit) * 8); }
.ocelot-box--margin-10 { margin: calc(var(--ocelot-spacing-unit) * 10); }
.ocelot-box--margin-12 { margin: calc(var(--ocelot-spacing-unit) * 12); }

.ocelot-box--radius-sm  { border-radius: var(--ocelot-radius-sm); }
.ocelot-box--radius-md  { border-radius: var(--ocelot-radius-md); }
.ocelot-box--radius-lg  { border-radius: var(--ocelot-radius-lg); }

.ocelot-box--shadow-sm  { box-shadow: var(--ocelot-shadow-sm); }
.ocelot-box--shadow-md  { box-shadow: var(--ocelot-shadow-md); }
.ocelot-box--shadow-lg  { box-shadow: var(--ocelot-shadow-lg); }

.ocelot-box--border     { border: 1px solid var(--ocelot-border); }
.ocelot-box--border-strong { border: 1px solid var(--ocelot-border-strong); }

.ocelot-box--bg-surface      { background: var(--ocelot-surface); }
.ocelot-box--bg-surface-raised { background: var(--ocelot-surface-raised); }
.ocelot-box--bg-surface-muted  { background: var(--ocelot-surface-muted); }
.ocelot-box--bg-primary      { background: var(--ocelot-primary); }
|}

let stack_styles =
  {|
.ocelot-stack {
  display: flex;
  flex-direction: column;
}

.ocelot-stack--gap-0  { gap: 0; }
.ocelot-stack--gap-1  { gap: calc(var(--ocelot-spacing-unit) * 1); }
.ocelot-stack--gap-2  { gap: calc(var(--ocelot-spacing-unit) * 2); }
.ocelot-stack--gap-3  { gap: calc(var(--ocelot-spacing-unit) * 3); }
.ocelot-stack--gap-4  { gap: calc(var(--ocelot-spacing-unit) * 4); }
.ocelot-stack--gap-5  { gap: calc(var(--ocelot-spacing-unit) * 5); }
.ocelot-stack--gap-6  { gap: calc(var(--ocelot-spacing-unit) * 6); }
.ocelot-stack--gap-8  { gap: calc(var(--ocelot-spacing-unit) * 8); }

.ocelot-flex {
  display: flex;
}

.ocelot-flex--row    { flex-direction: row; }
.ocelot-flex--column { flex-direction: column; }

.ocelot-flex--gap-0  { gap: 0; }
.ocelot-flex--gap-1  { gap: calc(var(--ocelot-spacing-unit) * 1); }
.ocelot-flex--gap-2  { gap: calc(var(--ocelot-spacing-unit) * 2); }
.ocelot-flex--gap-3  { gap: calc(var(--ocelot-spacing-unit) * 3); }
.ocelot-flex--gap-4  { gap: calc(var(--ocelot-spacing-unit) * 4); }
.ocelot-flex--gap-5  { gap: calc(var(--ocelot-spacing-unit) * 5); }
.ocelot-flex--gap-6  { gap: calc(var(--ocelot-spacing-unit) * 6); }
.ocelot-flex--gap-8  { gap: calc(var(--ocelot-spacing-unit) * 8); }

.ocelot-flex--align-start    { align-items: flex-start; }
.ocelot-flex--align-center   { align-items: center; }
.ocelot-flex--align-end      { align-items: flex-end; }
.ocelot-flex--justify-start  { justify-content: flex-start; }
.ocelot-flex--justify-center { justify-content: center; }
.ocelot-flex--justify-end    { justify-content: flex-end; }
.ocelot-flex--justify-between { justify-content: space-between; }
|}

let text_styles =
  {|
.ocelot-text {
  font-family: var(--ocelot-font-body);
  color: var(--ocelot-text-primary);
  line-height: 1.5;
}

.ocelot-text--sm  { font-size: var(--ocelot-font-size-sm); }
.ocelot-text--md  { font-size: var(--ocelot-font-size-md); }
.ocelot-text--lg  { font-size: var(--ocelot-font-size-lg); }
.ocelot-text--xl  { font-size: var(--ocelot-font-size-xl); }

.ocelot-text--weight-normal { font-weight: 400; }
.ocelot-text--weight-medium { font-weight: 500; }
.ocelot-text--weight-semibold { font-weight: 600; }
.ocelot-text--weight-bold   { font-weight: 700; }

.ocelot-text--align-left   { text-align: left; }
.ocelot-text--align-center { text-align: center; }
.ocelot-text--align-right  { text-align: right; }

.ocelot-text--color-primary   { color: var(--ocelot-text-primary); }
.ocelot-text--color-secondary { color: var(--ocelot-text-secondary); }
.ocelot-text--color-heading   { color: var(--ocelot-text-heading); }
.ocelot-text--color-muted     { color: var(--ocelot-text-muted); }
.ocelot-text--color-primary-accent { color: var(--ocelot-primary); }
.ocelot-text--color-danger    { color: var(--ocelot-danger); }
.ocelot-text--color-success   { color: var(--ocelot-success); }
.ocelot-text--color-warning   { color: var(--ocelot-warning); }
.ocelot-text--color-info      { color: var(--ocelot-info); }
|}

let divider_styles =
  {|
.ocelot-divider {
  border: none;
  background: var(--ocelot-border);
}

.ocelot-divider--horizontal {
  width: 100%;
  height: 1px;
}

.ocelot-divider--vertical {
  width: 1px;
  height: 100%;
  display: inline-block;
}
|}

let button_styles =
  {|
.ocelot-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: calc(var(--ocelot-spacing-unit) * 1);
  font-family: var(--ocelot-font-body);
  font-weight: 500;
  line-height: 1.5;
  border: 1px solid transparent;
  border-radius: var(--ocelot-radius-md);
  cursor: pointer;
  text-decoration: none;
  transition: background-color 150ms ease, border-color 150ms ease, color 150ms ease, box-shadow 150ms ease;
}

.ocelot-button:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

.ocelot-button--sm {
  padding: calc(var(--ocelot-spacing-unit) * 1) calc(var(--ocelot-spacing-unit) * 2.5);
  font-size: var(--ocelot-font-size-sm);
}

.ocelot-button--md {
  padding: calc(var(--ocelot-spacing-unit) * 1.5) calc(var(--ocelot-spacing-unit) * 3);
  font-size: var(--ocelot-font-size-md);
}

.ocelot-button--lg {
  padding: calc(var(--ocelot-spacing-unit) * 2) calc(var(--ocelot-spacing-unit) * 4);
  font-size: var(--ocelot-font-size-lg);
}

.ocelot-button--primary {
  background: var(--ocelot-primary);
  color: oklch(100% 0 0);
}
.ocelot-button--primary:hover {
  background: var(--ocelot-primary-hover);
}
.ocelot-button--primary:active {
  background: var(--ocelot-primary-active);
}

.ocelot-button--secondary {
  background: var(--ocelot-surface-raised);
  color: var(--ocelot-text-primary);
  border-color: var(--ocelot-border);
}
.ocelot-button--secondary:hover {
  background: var(--ocelot-surface-muted);
  border-color: var(--ocelot-border-strong);
}

.ocelot-button--ghost {
  background: transparent;
  color: var(--ocelot-text-primary);
}
.ocelot-button--ghost:hover {
  background: var(--ocelot-surface-muted);
}

.ocelot-button--danger {
  background: var(--ocelot-danger);
  color: oklch(100% 0 0);
}
.ocelot-button--danger:hover {
  background: var(--ocelot-danger-hover);
}

.ocelot-button:disabled,
.ocelot-button[aria-disabled="true"] {
  opacity: var(--ocelot-disabled-opacity);
  cursor: not-allowed;
}
|}

let link_styles =
  {|
.ocelot-link {
  color: var(--ocelot-primary);
  text-decoration: underline;
  text-underline-offset: 2px;
  text-decoration-thickness: 1.5px;
  font-weight: 500;
  transition: color 150ms ease;
}

.ocelot-link:hover {
  color: var(--ocelot-primary-hover);
}

.ocelot-link--muted {
  color: var(--ocelot-text-muted);
}
.ocelot-link--muted:hover {
  color: var(--ocelot-text-secondary);
}

.ocelot-link:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}
|}

let input_styles =
  {|
.ocelot-input,
.ocelot-textarea {
  display: block;
  width: 100%;
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-md);
  color: var(--ocelot-text-primary);
  background: var(--ocelot-surface);
  border: 1px solid var(--ocelot-border);
  border-radius: var(--ocelot-radius-md);
  padding: calc(var(--ocelot-spacing-unit) * 1.5) calc(var(--ocelot-spacing-unit) * 3);
  line-height: 1.5;
  transition: border-color 150ms ease, box-shadow 150ms ease;
}

.ocelot-input::placeholder,
.ocelot-textarea::placeholder {
  color: var(--ocelot-text-muted);
}

.ocelot-input:focus-visible,
.ocelot-textarea:focus-visible {
  outline: none;
  border-color: var(--ocelot-primary);
  box-shadow: 0 0 0 3px var(--ocelot-focus-ring);
}

.ocelot-input:disabled,
.ocelot-textarea:disabled {
  opacity: var(--ocelot-disabled-opacity);
  cursor: not-allowed;
  background: var(--ocelot-surface-muted);
}

.ocelot-textarea {
  resize: vertical;
  min-height: calc(var(--ocelot-spacing-unit) * 20);
}

.ocelot-label {
  display: block;
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
  font-weight: 500;
  color: var(--ocelot-text-secondary);
  margin-bottom: calc(var(--ocelot-spacing-unit) * 1);
}
|}

let badge_styles =
  {|
.ocelot-badge {
  display: inline-flex;
  align-items: center;
  gap: calc(var(--ocelot-spacing-unit) * 1);
  padding: calc(var(--ocelot-spacing-unit) * 0.5) calc(var(--ocelot-spacing-unit) * 2);
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
  font-weight: 500;
  line-height: 1.4;
  border-radius: var(--ocelot-radius-sm);
  border: 1px solid transparent;
}

.ocelot-badge--primary {
  background: var(--ocelot-primary);
  color: oklch(100% 0 0);
}

.ocelot-badge--secondary {
  background: var(--ocelot-surface-raised);
  color: var(--ocelot-text-primary);
  border-color: var(--ocelot-border);
}

.ocelot-badge--success {
  background: var(--ocelot-success);
  color: oklch(100% 0 0);
}

.ocelot-badge--warning {
  background: var(--ocelot-warning);
  color: oklch(25% 0 0);
}

.ocelot-badge--danger {
  background: var(--ocelot-danger);
  color: oklch(100% 0 0);
}

.ocelot-badge--info {
  background: var(--ocelot-info);
  color: oklch(100% 0 0);
}
|}

let alert_styles =
  {|
.ocelot-alert {
  display: flex;
  align-items: flex-start;
  gap: calc(var(--ocelot-spacing-unit) * 3);
  padding: calc(var(--ocelot-spacing-unit) * 3) calc(var(--ocelot-spacing-unit) * 4);
  border-radius: var(--ocelot-radius-md);
  border: 1px solid transparent;
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-md);
  line-height: 1.5;
}

.ocelot-alert--success {
  background: color-mix(in oklch, var(--ocelot-success) 12%, transparent);
  color: var(--ocelot-success);
  border-color: color-mix(in oklch, var(--ocelot-success) 35%, transparent);
}

.ocelot-alert--warning {
  background: color-mix(in oklch, var(--ocelot-warning) 12%, transparent);
  color: var(--ocelot-warning);
  border-color: color-mix(in oklch, var(--ocelot-warning) 35%, transparent);
}

.ocelot-alert--danger {
  background: color-mix(in oklch, var(--ocelot-danger) 12%, transparent);
  color: var(--ocelot-danger);
  border-color: color-mix(in oklch, var(--ocelot-danger) 35%, transparent);
}

.ocelot-alert--info {
  background: color-mix(in oklch, var(--ocelot-info) 12%, transparent);
  color: var(--ocelot-info);
  border-color: color-mix(in oklch, var(--ocelot-info) 35%, transparent);
}
|}

let card_styles =
  {|
.ocelot-card {
  display: flex;
  flex-direction: column;
  background: var(--ocelot-surface);
  border: 1px solid var(--ocelot-border);
  border-radius: var(--ocelot-radius-lg);
  overflow: hidden;
}

.ocelot-card--shadow-sm  { box-shadow: var(--ocelot-shadow-sm); }
.ocelot-card--shadow-md  { box-shadow: var(--ocelot-shadow-md); }
.ocelot-card--shadow-lg  { box-shadow: var(--ocelot-shadow-lg); }

.ocelot-card__header {
  padding: calc(var(--ocelot-spacing-unit) * 4) calc(var(--ocelot-spacing-unit) * 5) 0;
  font-family: var(--ocelot-font-body);
}

.ocelot-card__body {
  padding: calc(var(--ocelot-spacing-unit) * 3) calc(var(--ocelot-spacing-unit) * 5);
  font-family: var(--ocelot-font-body);
  color: var(--ocelot-text-primary);
  line-height: 1.6;
}

.ocelot-card__footer {
  padding: 0 calc(var(--ocelot-spacing-unit) * 5) calc(var(--ocelot-spacing-unit) * 4);
  font-family: var(--ocelot-font-body);
}
|}

let table_styles =
  {|
.ocelot-table-wrapper {
  overflow-x: auto;
  border: 1px solid var(--ocelot-border);
  border-radius: var(--ocelot-radius-md);
}

.ocelot-table {
  width: 100%;
  border-collapse: collapse;
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
  line-height: 1.5;
}

.ocelot-table th,
.ocelot-table td {
  padding: calc(var(--ocelot-spacing-unit) * 2.5) calc(var(--ocelot-spacing-unit) * 4);
  text-align: left;
  border-bottom: 1px solid var(--ocelot-border);
}

.ocelot-table th {
  font-weight: 600;
  color: var(--ocelot-text-secondary);
  background: var(--ocelot-surface-muted);
  text-transform: uppercase;
  letter-spacing: 0.03em;
  font-size: var(--ocelot-font-size-sm);
}

.ocelot-table tbody tr:last-child td {
  border-bottom: none;
}

.ocelot-table tbody tr:hover {
  background: var(--ocelot-surface-muted);
}
|}

let breadcrumb_styles =
  {|
.ocelot-breadcrumb {
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
}

.ocelot-breadcrumb__list {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: calc(var(--ocelot-spacing-unit) * 2);
  list-style: none;
  margin: 0;
  padding: 0;
}

.ocelot-breadcrumb__item {
  display: inline-flex;
  align-items: center;
  gap: calc(var(--ocelot-spacing-unit) * 2);
}

.ocelot-breadcrumb__item:last-child .ocelot-breadcrumb__separator {
  display: none;
}

.ocelot-breadcrumb__link {
  color: var(--ocelot-text-muted);
  text-decoration: none;
  transition: color 150ms ease;
}

.ocelot-breadcrumb__link:hover {
  color: var(--ocelot-text-secondary);
}

.ocelot-breadcrumb__link:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

.ocelot-breadcrumb__current {
  font-weight: 600;
  color: var(--ocelot-text-primary);
}

.ocelot-breadcrumb__separator {
  color: var(--ocelot-text-muted);
  user-select: none;
}
|}

let tabs_styles =
  {|
.ocelot-tabs__list {
  display: flex;
  align-items: center;
  gap: calc(var(--ocelot-spacing-unit) * 1);
  border-bottom: 1px solid var(--ocelot-border);
  list-style: none;
  margin: 0;
  padding: 0;
  font-family: var(--ocelot-font-body);
}

.ocelot-tabs__tab {
  padding: calc(var(--ocelot-spacing-unit) * 2) calc(var(--ocelot-spacing-unit) * 3);
  font-size: var(--ocelot-font-size-sm);
  font-weight: 500;
  color: var(--ocelot-text-muted);
  background: transparent;
  border: none;
  border-bottom: 2px solid transparent;
  margin-bottom: -1px;
  cursor: pointer;
  transition: color 150ms ease, border-color 150ms ease;
}

.ocelot-tabs__tab:hover {
  color: var(--ocelot-text-secondary);
}

.ocelot-tabs__tab[aria-selected="true"] {
  color: var(--ocelot-primary);
  border-bottom-color: var(--ocelot-primary);
}

.ocelot-tabs__tab:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

.ocelot-tabs__panel {
  padding-top: calc(var(--ocelot-spacing-unit) * 4);
}

.ocelot-tabs__panel[hidden] {
  display: none;
}
|}

let accordion_styles =
  {|
.ocelot-accordion__item {
  border-bottom: 1px solid var(--ocelot-border);
}

.ocelot-accordion__trigger {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  padding: calc(var(--ocelot-spacing-unit) * 3) 0;
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-md);
  font-weight: 500;
  color: var(--ocelot-text-primary);
  background: transparent;
  border: none;
  cursor: pointer;
  text-align: left;
  transition: color 150ms ease;
}

.ocelot-accordion__trigger:hover {
  color: var(--ocelot-primary);
}

.ocelot-accordion__trigger:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

.ocelot-accordion__icon {
  display: inline-block;
  transition: transform 200ms ease;
}

.ocelot-accordion__trigger[aria-expanded="true"] .ocelot-accordion__icon {
  transform: rotate(180deg);
}

.ocelot-accordion__panel {
  padding-bottom: calc(var(--ocelot-spacing-unit) * 3);
  color: var(--ocelot-text-secondary);
  line-height: 1.6;
}
|}

let modal_styles =
  {|
.ocelot-modal {
  position: fixed;
  inset: 0;
  z-index: 50;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: calc(var(--ocelot-spacing-unit) * 4);
}

.ocelot-modal__backdrop {
  position: absolute;
  inset: 0;
  background: oklch(0% 0 0 / 0.45);
}

.ocelot-modal__content {
  position: relative;
  z-index: 1;
  width: 100%;
  max-width: 28rem;
  background: var(--ocelot-surface);
  border: 1px solid var(--ocelot-border);
  border-radius: var(--ocelot-radius-lg);
  box-shadow: var(--ocelot-shadow-lg);
  padding: calc(var(--ocelot-spacing-unit) * 6);
}

.ocelot-modal__header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: calc(var(--ocelot-spacing-unit) * 3);
  margin-bottom: calc(var(--ocelot-spacing-unit) * 4);
}

.ocelot-modal__title {
  margin: 0;
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-lg);
  font-weight: 600;
  color: var(--ocelot-text-heading);
}

.ocelot-modal__close {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  padding: 0;
  background: transparent;
  border: none;
  border-radius: var(--ocelot-radius-sm);
  color: var(--ocelot-text-muted);
  cursor: pointer;
  transition: background-color 150ms ease, color 150ms ease;
}

.ocelot-modal__close:hover {
  background: var(--ocelot-surface-muted);
  color: var(--ocelot-text-primary);
}

.ocelot-modal__close:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}
|}

let pagination_styles =
  {|
.ocelot-pagination {
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
}

.ocelot-pagination__list {
  display: flex;
  align-items: center;
  gap: calc(var(--ocelot-spacing-unit) * 1);
  list-style: none;
  margin: 0;
  padding: 0;
}

.ocelot-pagination__item {
  display: inline-flex;
}

.ocelot-pagination__link,
.ocelot-pagination__ellipsis {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 2.25rem;
  height: 2.25rem;
  padding: 0 calc(var(--ocelot-spacing-unit) * 2);
  border-radius: var(--ocelot-radius-md);
  color: var(--ocelot-text-secondary);
  text-decoration: none;
  font-weight: 500;
  transition: background-color 150ms ease, color 150ms ease;
}

.ocelot-pagination__link:hover {
  background: var(--ocelot-surface-muted);
  color: var(--ocelot-text-primary);
}

.ocelot-pagination__link:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

.ocelot-pagination__link[aria-current="page"] {
  background: var(--ocelot-primary);
  color: oklch(100% 0 0);
}

.ocelot-pagination__link[aria-disabled="true"] {
  opacity: var(--ocelot-disabled-opacity);
  cursor: not-allowed;
  pointer-events: none;
}
|}

let tooltip_styles =
  {|
.ocelot-tooltip {
  position: relative;
  display: inline-block;
}

.ocelot-tooltip__trigger {
  cursor: help;
  border-bottom: 1px dashed var(--ocelot-text-muted);
  text-decoration: none;
}

.ocelot-tooltip__trigger:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

.ocelot-tooltip__content {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  bottom: calc(100% + 0.5rem);
  z-index: 40;
  max-width: 16rem;
  padding: calc(var(--ocelot-spacing-unit) * 1.5) calc(var(--ocelot-spacing-unit) * 2.5);
  background: var(--ocelot-text-primary);
  color: var(--ocelot-surface);
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
  line-height: 1.4;
  border-radius: var(--ocelot-radius-sm);
  box-shadow: var(--ocelot-shadow-md);
  pointer-events: none;
}

.ocelot-tooltip--bottom .ocelot-tooltip__content {
  bottom: auto;
  top: calc(100% + 0.5rem);
}
|}

let select_styles =
  {|
select.ocelot-input {
  appearance: none;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 0.75rem center;
  background-size: 1rem;
  padding-right: 2.5rem;
}
|}

let toast_styles =
  {|
.ocelot-toast-container {
  position: fixed;
  bottom: calc(var(--ocelot-spacing-unit) * 5);
  right: calc(var(--ocelot-spacing-unit) * 5);
  z-index: 60;
  display: flex;
  flex-direction: column;
  gap: calc(var(--ocelot-spacing-unit) * 2);
  max-width: 22rem;
}

.ocelot-toast {
  position: relative;
  padding-right: calc(var(--ocelot-spacing-unit) * 10);
  box-shadow: var(--ocelot-shadow-lg);
}

.ocelot-toast__dismiss {
  position: absolute;
  top: calc(var(--ocelot-spacing-unit) * 2.5);
  right: calc(var(--ocelot-spacing-unit) * 2.5);
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 1.5rem;
  height: 1.5rem;
  padding: 0;
  background: transparent;
  border: none;
  border-radius: var(--ocelot-radius-sm);
  color: inherit;
  cursor: pointer;
  opacity: 0.7;
  transition: opacity 150ms ease;
}

.ocelot-toast__dismiss:hover {
  opacity: 1;
}

.ocelot-toast__dismiss:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}
|}

let dropdown_styles =
  {|
.ocelot-dropdown {
  position: relative;
  display: inline-block;
}

.ocelot-dropdown__icon {
  display: inline-block;
  transition: transform 200ms ease;
}

.ocelot-dropdown__menu {
  position: absolute;
  top: calc(100% + calc(var(--ocelot-spacing-unit) * 1));
  left: 0;
  min-width: 12rem;
  margin: 0;
  padding: calc(var(--ocelot-spacing-unit) * 1);
  list-style: none;
  background: var(--ocelot-surface);
  border: 1px solid var(--ocelot-border);
  border-radius: var(--ocelot-radius-md);
  box-shadow: var(--ocelot-shadow-lg);
  z-index: 50;
}

.ocelot-dropdown__option {
  display: flex;
  align-items: center;
  padding: calc(var(--ocelot-spacing-unit) * 2) calc(var(--ocelot-spacing-unit) * 2.5);
  border-radius: var(--ocelot-radius-sm);
  color: var(--ocelot-text-secondary);
  cursor: pointer;
}

.ocelot-dropdown__option--active {
  background: var(--ocelot-surface-muted);
  color: var(--ocelot-text-primary);
}

.ocelot-dropdown__option--selected {
  color: var(--ocelot-primary);
  font-weight: 600;
}
|}

let modal_extras = {|
.ocelot-modal__trigger {
  display: inline-flex;
}
|}

let checkbox_styles =
  {|
.ocelot-checkbox,
.ocelot-radio,
.ocelot-switch {
  display: inline-flex;
  align-items: center;
  gap: calc(var(--ocelot-spacing-unit) * 2);
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-md);
  color: var(--ocelot-text-primary);
  cursor: pointer;
  user-select: none;
}

/* The real inputs are visually hidden but stay in the layout's
   accessibility tree: focus, keyboard activation, and form submission
   all remain native. */
.ocelot-checkbox__input,
.ocelot-radio__input,
.ocelot-switch__input {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: 0;
  padding: 0;
  opacity: 0;
  pointer-events: none;
}

.ocelot-checkbox:has(input:disabled),
.ocelot-radio:has(input:disabled),
.ocelot-switch:has(input:disabled) {
  opacity: var(--ocelot-disabled-opacity);
  cursor: not-allowed;
}

.ocelot-checkbox__box {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: none;
  width: 1rem;
  height: 1rem;
  background: var(--ocelot-surface);
  border: 1px solid var(--ocelot-border-strong);
  border-radius: var(--ocelot-radius-sm);
  transition: background-color 150ms ease, border-color 150ms ease;
}

.ocelot-checkbox__indicator {
  display: block;
  width: 0.25rem;
  height: 0.5rem;
  margin-top: -0.125rem;
  border: solid oklch(100% 0 0);
  border-width: 0 2px 2px 0;
  transform: rotate(45deg) scale(0);
  transform-origin: center;
  transition: transform 150ms ease;
}

.ocelot-checkbox__input:checked + .ocelot-checkbox__box {
  background: var(--ocelot-primary);
  border-color: var(--ocelot-primary);
}

.ocelot-checkbox__input:checked + .ocelot-checkbox__box .ocelot-checkbox__indicator {
  transform: rotate(45deg) scale(1);
}

.ocelot-checkbox__input:focus-visible + .ocelot-checkbox__box {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}
|}

let radio_group_styles =
  {|
.ocelot-radio-group {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: calc(var(--ocelot-spacing-unit) * 2);
  margin: 0;
  padding: 0;
  border: none;
}

.ocelot-radio-group__legend {
  padding: 0;
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
  font-weight: 500;
  color: var(--ocelot-text-secondary);
}

.ocelot-radio-group:disabled .ocelot-radio {
  opacity: var(--ocelot-disabled-opacity);
  cursor: not-allowed;
}

.ocelot-radio__circle {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: none;
  width: 1rem;
  height: 1rem;
  background: var(--ocelot-surface);
  border: 1px solid var(--ocelot-border-strong);
  border-radius: 50%;
  transition: border-color 150ms ease;
}

.ocelot-radio__dot {
  width: 0.5rem;
  height: 0.5rem;
  border-radius: 50%;
  background: var(--ocelot-primary);
  transform: scale(0);
  transition: transform 150ms ease;
}

.ocelot-radio__input:checked + .ocelot-radio__circle {
  border-color: var(--ocelot-primary);
}

.ocelot-radio__input:checked + .ocelot-radio__circle .ocelot-radio__dot {
  transform: scale(1);
}

.ocelot-radio__input:focus-visible + .ocelot-radio__circle {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}
|}

let switch_styles =
  {|
.ocelot-switch__track {
  position: relative;
  flex: none;
  width: 2.25rem;
  height: 1.25rem;
  border-radius: 9999px;
  background: var(--ocelot-border-strong);
  transition: background-color 200ms ease;
}

.ocelot-switch__thumb {
  position: absolute;
  top: 0.125rem;
  left: 0.125rem;
  width: 1rem;
  height: 1rem;
  border-radius: 50%;
  background: var(--ocelot-surface);
  box-shadow: var(--ocelot-shadow-sm);
  transition: transform 200ms ease;
}

.ocelot-switch__input:checked + .ocelot-switch__track {
  background: var(--ocelot-primary);
}

.ocelot-switch__input:checked + .ocelot-switch__track .ocelot-switch__thumb {
  transform: translateX(1rem);
}

.ocelot-switch__input:focus-visible + .ocelot-switch__track {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}
|}

let progress_styles =
  {|
.ocelot-progress {
  width: 100%;
  height: 0.5rem;
  background: var(--ocelot-surface-muted);
  border-radius: 9999px;
  overflow: hidden;
}

.ocelot-progress__indicator {
  height: 100%;
  background: var(--ocelot-primary);
  border-radius: 9999px;
  transition: width 200ms ease;
}

.ocelot-progress--indeterminate .ocelot-progress__indicator {
  width: 40%;
  animation: ocelot-progress-indeterminate 1.5s ease-in-out infinite;
}

@keyframes ocelot-progress-indeterminate {
  0% {
    transform: translateX(-100%);
  }

  100% {
    transform: translateX(250%);
  }
}
|}

let scroll_area_styles =
  {|
.ocelot-scroll-area {
  overflow: hidden;
  scrollbar-width: thin;
  scrollbar-color: var(--ocelot-border-strong) transparent;
}

.ocelot-scroll-area--vertical {
  overflow-y: auto;
}

.ocelot-scroll-area--horizontal {
  overflow-x: auto;
}

.ocelot-scroll-area::-webkit-scrollbar {
  width: 0.5rem;
  height: 0.5rem;
}

.ocelot-scroll-area::-webkit-scrollbar-track {
  background: transparent;
}

.ocelot-scroll-area::-webkit-scrollbar-thumb {
  background: var(--ocelot-border-strong);
  border-radius: 9999px;
}

.ocelot-scroll-area::-webkit-scrollbar-thumb:hover {
  background: var(--ocelot-text-muted);
}
|}

let spinner_styles =
  {|
.ocelot-spinner {
  display: inline-flex;
  align-items: center;
  gap: calc(var(--ocelot-spacing-unit) * 2);
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
  color: var(--ocelot-text-secondary);
}

.ocelot-spinner__icon {
  display: inline-block;
  flex: none;
  border: 2px solid var(--ocelot-border);
  border-top-color: var(--ocelot-primary);
  border-radius: 50%;
  animation: ocelot-spin 600ms linear infinite;
}

.ocelot-spinner--sm .ocelot-spinner__icon {
  width: 0.875rem;
  height: 0.875rem;
}

.ocelot-spinner--md .ocelot-spinner__icon {
  width: 1.25rem;
  height: 1.25rem;
}

.ocelot-spinner--lg .ocelot-spinner__icon {
  width: 1.75rem;
  height: 1.75rem;
  border-width: 3px;
}

@keyframes ocelot-spin {
  to {
    transform: rotate(360deg);
  }
}

@media (prefers-reduced-motion: reduce) {
  .ocelot-spinner__icon,
  .ocelot-progress--indeterminate .ocelot-progress__indicator {
    animation-duration: 1.5s;
  }
}
|}

let calendar_styles =
  {|
.ocelot-calendar {
  display: inline-block;
  font-family: var(--ocelot-font-body);
  color: var(--ocelot-text-primary);
}

.ocelot-calendar__header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: calc(var(--ocelot-spacing-unit) * 2);
  margin-bottom: calc(var(--ocelot-spacing-unit) * 3);
}

.ocelot-calendar__title {
  font-size: var(--ocelot-font-size-md);
  font-weight: 600;
  color: var(--ocelot-text-heading);
}

.ocelot-calendar__nav {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  border-radius: var(--ocelot-radius-sm);
  background: transparent;
  color: var(--ocelot-text-secondary);
  font-size: 1.25rem;
  line-height: 1;
  text-decoration: none;
  cursor: pointer;
  transition: background-color 150ms ease, color 150ms ease;
}

.ocelot-calendar__nav:hover {
  background: var(--ocelot-surface-muted);
  color: var(--ocelot-text-primary);
}

.ocelot-calendar__nav:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

.ocelot-calendar__grid {
  border-collapse: collapse;
}

.ocelot-calendar__weekday {
  padding: 0 0 calc(var(--ocelot-spacing-unit) * 1);
  font-size: var(--ocelot-font-size-sm);
  font-weight: 500;
  color: var(--ocelot-text-muted);
  text-align: center;
}

.ocelot-calendar__cell {
  padding: 2px;
  text-align: center;
}

.ocelot-calendar__day {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 2.25rem;
  height: 2.25rem;
  border: none;
  border-radius: var(--ocelot-radius-md);
  background: transparent;
  color: var(--ocelot-text-primary);
  font-family: var(--ocelot-font-body);
  font-size: var(--ocelot-font-size-sm);
  cursor: pointer;
  transition: background-color 150ms ease, color 150ms ease;
}

.ocelot-calendar__day:hover {
  background: var(--ocelot-surface-muted);
}

.ocelot-calendar__day:focus-visible {
  outline: 2px solid var(--ocelot-focus-ring);
  outline-offset: 2px;
}

.ocelot-calendar__day--selected,
.ocelot-calendar__day--selected:hover {
  background: var(--ocelot-primary);
  color: oklch(100% 0 0);
  font-weight: 600;
}

.ocelot-calendar__day--today {
  box-shadow: inset 0 0 0 1px var(--ocelot-primary);
}

.ocelot-calendar__day--selected.ocelot-calendar__day--today {
  box-shadow: inset 0 0 0 1px oklch(100% 0 0);
}

.ocelot-calendar__day:disabled {
  opacity: var(--ocelot-disabled-opacity);
  cursor: not-allowed;
}
|}

let all ~(light : Theme.t) ~(dark : Theme.t) : string =
  String.concat "\n\n"
    [
      theme_variables ~light ~dark;
      base_reset;
      box_styles;
      stack_styles;
      text_styles;
      divider_styles;
      button_styles;
      link_styles;
      input_styles;
      badge_styles;
      alert_styles;
      card_styles;
      table_styles;
      breadcrumb_styles;
      tabs_styles;
      accordion_styles;
      modal_styles;
      pagination_styles;
      tooltip_styles;
      select_styles;
      toast_styles;
      dropdown_styles;
      modal_extras;
      checkbox_styles;
      radio_group_styles;
      switch_styles;
      progress_styles;
      scroll_area_styles;
      spinner_styles;
      calendar_styles;
    ]
