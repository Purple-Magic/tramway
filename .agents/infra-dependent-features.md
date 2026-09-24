## Infra-dependent features must fail with clear errors

When you implement a feature that only works with specific infrastructure present in the host
application (a particular database adapter, a particular external service, a particular OS-level
binary, etc.), do not let it fail with a raw, low-level error when that infrastructure is missing.
Detect the missing dependency up front and raise a clear, actionable error explaining what is
required and how to work around it.

### Example: PostgreSQL-only features

Tramway's default entities#index search (`Model.tramway_search`) uses the `pg_search` gem, which
depends on PostgreSQL's full-text search functions (`to_tsvector`/`to_tsquery`). If the host
application's database is not PostgreSQL (e.g. SQLite, MySQL), this feature cannot work.

Instead of letting the underlying SQL fail with a confusing adapter error, Tramway checks the
adapter before using `pg_search` and raises `Tramway::Errors::UnsupportedDatabaseAdapterError`
(see `lib/tramway/pg_searchable.rb` and `lib/tramway/errors.rb`), telling the developer:

- what feature failed and why,
- which infrastructure is required,
- how to fix it (switch adapters, or define their own `Model.search(query)` scope).

### How to apply this pattern

- Identify the infrastructure precondition (adapter name, presence of a gem/service/ENV var) as
  early as possible, before any operation that would fail with a cryptic low-level error.
- Raise a dedicated error class under `Tramway::Errors` with a message that names the feature, the
  missing infrastructure, and a concrete next step for the developer.
- Do not silently no-op or swallow the failure — a developer must see why the feature does not
  work in their environment.
- Add a test that exercises the missing-infrastructure path (see
  `spec/tramway/pg_searchable_spec.rb` for the pattern), not just the happy path.
