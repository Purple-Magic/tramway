# Tramway design system

Tramway renders its UI with the TimeMagic design system. Dark is the only look; there is no theme switch.
(The `config.theme` option that earlier versions had was removed in 5.0.)

## Where it lives

| What | File |
|---|---|
| Entry point imported by `tailwindcss-rails` | `app/assets/tailwind/tramway/engine.css` |
| Design tokens (`--tramway-*`) | `app/assets/tailwind/tramway/tokens.css` |
| Cursor, focus ring, press feedback, reduced motion | `app/assets/tailwind/tramway/base.css` |
| Primitives (`tramway-*` classes) | `app/assets/tailwind/tramway/components/*.css` |

`bin/rails tailwindcss:build` generates `app/assets/builds/tailwind/tramway.css`, which imports `engine.css`. The host's
`app/assets/tailwind/application.css` imports that file (`rails g tramway:install` adds the line). `engine.css` also adds
`@source` entries so Tailwind sees the utilities used inside Tramway's own templates.

Primitives are plain CSS in `@layer components`, so any Tailwind utility passed through `class:` still wins.

## Type / color to variant mapping

`Tramway::ColorsMethods::TYPE_VARIANT_MAP`:

| Tramway type | Variant |
|---|---|
| default, secondary, life | secondary (neutral surface) |
| primary, hope | primary (accent) |
| success, will | success |
| submit | submit (solid green, the one focal action of a form) |
| warning, greed | warning |
| danger, rage | danger |
| inverse | ghost |
| love | primary (violet has no variant; the accent is the closest) |
| compassion | secondary (indigo is used for cancel-like actions, which should stay neutral) |
| fear | warning (yellow is the closest) |

An explicit `color:` that is a Tailwind color name and not a Tramway type renders the generic tinted variant
(`tramway-button--tint tramway-tint--teal`): the tint comes from `--tramway-tint`, so the color is a fixed CSS class and
nothing is interpolated into Tailwind utilities at runtime.

## Primitive classes

typography (`tramway-text-*`, `tramway-title`, `tramway-prose`), layout (`tramway-main`, `tramway-container`,
`tramway-card`, `tramway-grid`, `tramway-grid-card`), `tramway-button`, `tramway-badge`, `tramway-flash`,
`tramway-alert`, form (`tramway-form__field|label|control|hint|error|error-summary|required|input|textarea|select|
check-input|file-button|actions|rich-text`), `tramway-select__*`, `tramway-data-table*`, `tramway-pagination*`,
`tramway-navbar*`, `tramway-nav-item*`, `tramway-tooltip*`, `tramway-chat__*`, `tramway-progress`,
`tramway-empty-state`, `tramway-disclosure`, `tramway-breadcrumb`.

## Buttons, navbar and page header (TimeMagic conventions)

- Scaffolded pages use the TimeMagic button roles: **New** is `primary` (solid accent), **Edit** is `secondary`,
  **Destroy** is `danger`, filters and toggles are `ghost`/`primary`. The form's **Save** is the solid green `submit`.
- The navbar is the TimeMagic sidebar: 220px wide (72px collapsed) on the `surface` color with a right border; a brand
  row with an accent tile (the title's initial) and the title on the left and the bordered collapse button on the right;
  42px nav items with an icon, label and accent-tinted active state, 24px between the two item lists. Collapsed, only the
  brand tile and the icons stay; the tile expands the sidebar again. Collapsed items get a `title` tooltip with their
  label. The sizes are the `--tramway-shell-sidebar-width(-collapsed)` tokens and are applied by unlayered CSS, so the
  `md:w-72` / `md:pl-72` classes in older host layouts no longer matter.
- `.tramway-page-header__top` puts the page title (`tramway-title`, 22px on phones) on the left and the actions on the
  right; it stacks on small screens.

## Notes for contributors

- **Checkbox.** The box, accent fill and white check are styled from `data-state` by `.tramway-form__check-input`. The
  `ui--checkbox` controller only syncs `data-state`, `aria-checked`, the disabled state and the indicator's `hidden`
  attribute.
- **Table.** Rows are CSS grids whose columns come from an inline style and the table keeps its horizontal scroll
  container on narrow screens (the TimeMagic `tm-data-table` hides columns instead; Tramway cannot know which columns
  are unimportant). Only rows that link somewhere get the hover (`--clickable`).
- **Navbar.** The `tramway-navbar` Stimulus controller toggles a few Tailwind utilities (`md:w-72`/`md:w-24`,
  `md:pl-72`/`md:pl-24`, `hidden`, `-translate-x-full`); they stay in the markup and the safelist.
- **Active nav item.** `.tramway-nav-item[aria-current='page']` gets the active style.
- **Date, datetime and time inputs** stay native (`color-scheme: dark`); TimeMagic's popover picker is a follow-up.
- **Styleguide.** The dummy app renders every component at `/styleguide` (`spec/dummy`).
