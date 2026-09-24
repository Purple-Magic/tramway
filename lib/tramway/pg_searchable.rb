# frozen_string_literal: true

require 'tramway/errors'

module Tramway
  # Wires up a default, generic search across all string/text columns using the
  # `pg_search` gem, so entities#index search works out of the box for any model
  # that does not define its own `.search` scope.
  #
  # This is only supported on PostgreSQL, since pg_search depends on PostgreSQL's
  # full-text search functions. On any other adapter it raises a clear,
  # actionable error instead of failing with a confusing SQL error deep inside
  # pg_search.
  module PgSearchable
    module_function

    def call(model_class, query)
      ensure_postgres!(model_class)
      ensure_pg_search_scope!(model_class)

      model_class.tramway_pg_search(query)
    end

    def ensure_postgres!(model_class)
      adapter = model_class.connection.adapter_name

      return if adapter.casecmp('postgresql').zero?

      raise Tramway::Errors::UnsupportedDatabaseAdapterError.new(
        feature: 'the default entities#index search',
        model_class:,
        adapter:
      )
    end

    def ensure_pg_search_scope!(model_class)
      return if model_class.respond_to?(:tramway_pg_search)

      require 'pg_search'

      model_class.include(PgSearch::Model)
      model_class.pg_search_scope :tramway_pg_search,
                                  against: model_class.searchable_column_names,
                                  using: { tsearch: { prefix: true } }
    end
  end
end
