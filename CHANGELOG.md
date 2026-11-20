# Changelog

## 5.0.0

### Breaking (visual)

- **The default look is now the TimeMagic design system** for every component: buttons, badges, flash, forms (all
  inputs, the checkbox, `tramway_select`, rich text), tables, pagination, navbar, grid cards, title, tooltip, chat and the
  scaffolded entity pages.
- **The `theme` configuration option was removed with no replacement**, together with `Tramway::BaseComponent#tramway_theme`
  and `#theme_classes`. There is no way to get the old look back. A leftover `config.theme = ...` raises `NoMethodError`:
  delete the line.
- Presentation classes changed (for example `bg-zinc-950`, `bg-green-900/30`, `rounded-md` were replaced by
  `tramway-*` classes). Host code or specs that assert the old Tailwind classes need updating.

### Public API

Helpers, options, `type:`/`color:`/`size:` values, data attributes, ids, Stimulus controllers and submitted params are
unchanged. `type: :submit` renders the solid green submit button; `love`, `compassion` and `fear` map to the primary,
secondary and warning variants.

### Upgrade notes

1. Run `bin/rails g tramway:install` again (or add `@import "../builds/tailwind/tramway";` after
   `@import "tailwindcss";` in `app/assets/tailwind/application.css`).
2. Run `bin/rails tailwindcss:build`.
3. Remove `config.theme = ...` from `config/initializers/tramway.rb` if you set it.
4. You may delete the `.tramway-scrollbar` block the old installer copied into `application.css`; it now ships with Tramway.
5. Override any `--tramway-*` token in your own CSS to adapt the look.

### Added

- `--tramway-*` design tokens and `tramway-*` primitives (see `docs/users/tramway_design.md`).
- Styleguide page in the dummy app (`/styleguide`).

### Changed

- The Tailwind safelist no longer carries color utilities.
