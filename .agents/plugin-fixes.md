## Tramway is a Rails plugin — fix bugs in the gem, not in the host app

Tramway is distributed as a Rails plugin/gem and consumed by separate Rails applications. When
the user reports a bug they hit while using Tramway from a host Rails application (a JS error in
the browser console, a broken generator output, a view/component that misbehaves, an asset that
isn't wired up correctly), treat the root cause as living in this repository, not in the
consuming application.

### How to apply this

- Reproduce and fix the bug inside Tramway's own source: its view components
  (`app/components/tramway/**`), its JavaScript (`app/assets/javascripts/tramway/**`), its
  generators, or whatever Tramway-owned file actually produces the broken behavior.
- Do not tell the user to patch the generated/vendored code in their own Rails application as the
  fix. The host app should only need to upgrade the gem (or rerun an install generator) and have
  it "just work" afterwards.
- If the host application's report doesn't include enough detail to locate the Tramway-owned
  source (e.g. only a browser stack trace from a built asset), map it back to the corresponding
  file in this repo before fixing it.
- Add or extend a spec in this repo (e.g. under `spec/features/`) that reproduces the reported
  scenario, per the existing testing setup in `spec/dummy`, so the fix is verified here rather than
  only in the host app.
- If a generator or install step is what needs to change (e.g. to regenerate config/assets in the
  host app), update that generator so running it again produces the corrected output.
