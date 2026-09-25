## Creating a GitHub release

When the user asks to "make a release" (or equivalent), create a GitHub release using `gh release create`.

### Description format

Structure the release description as a set of `##` sections grouping changes by area/component (e.g. `## Tramway
Navbar`, `## Tramway Grid`, `## Fixes & Internals`), each containing a checklist of shipped changes:

```markdown
## <Area>

- [x] <change description>
- [x] <change description>

## Fixes & Internals

- [x] <change description>
```

End the description with a full changelog link comparing the previous tag to the new one:

```markdown
**Full Changelog**: https://github.com/Purple-Magic/tramway/compare/<previous_tag>...<new_tag>
```

Example of a complete release description:

```markdown
## Tramway

- [x] Dropped Rails 7.x support — now verified only against Rails 8.0 and 8.1
- [x] Removed `gemfiles/rails_7.0.gemfile`, `rails_7.1.gemfile`, `rails_7.2.gemfile`
- [x] Font Awesome is now bundled via the engine (`font-awesome-rails`), with font asset paths and
      `font-awesome.css` precompilation wired up automatically for Propshaft apps

## Tramway Navbar

- [x] Added `direction:` option to `tramway_navbar` (`:vertical` is now the default, `:horizontal` for the
      classic top navbar)
- [x] Default `:vertical` navbar now renders as a fixed, collapsible left sidebar on desktop (mobile always
      shows the top navbar regardless of `direction:`)

## Fixes & Internals

- [x] Fixed CSS class concatenation in `Containers::Main`/`Containers::Narrow` (previous string concatenation
      could produce classes glued together without a space)

**Full Changelog**: https://github.com/Purple-Magic/tramway/compare/3.1.2.8...4.0
```

### How to derive the content

- Group entries by the component/feature they touch, deriving groupings from `CHANGELOG.md`, `git log`, and merged
  PRs since the previous release/tag.
- Determine the previous tag with `git tag --sort=-creatordate` or `gh release list`.
- Determine the new tag/version from the gem's version file (e.g. `lib/tramway/version.rb`) unless the user
  specifies one.
- Use `gh release create <tag> --title <tag> --notes "<description>"` (or `--notes-file` for longer descriptions).
