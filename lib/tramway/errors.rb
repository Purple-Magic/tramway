# frozen_string_literal: true

module Tramway
  # Namespace for Tramway-specific error classes
  module Errors
    # Raised when a Tramway feature depends on infrastructure (e.g. a specific
    # database adapter) that the current application does not provide, so the
    # developer gets an actionable error instead of a raw, confusing failure
    # deep inside the underlying gem.
    class UnsupportedDatabaseAdapterError < StandardError
      def initialize(feature:, model_class:, adapter:, required_adapter: 'PostgreSQL')
        super(<<~MESSAGE)
          Tramway #{feature} requires #{required_adapter}, but #{model_class} is connected \
          through the "#{adapter}" adapter.

          This feature relies on the `pg_search` gem, which needs PostgreSQL's full-text \
          search functions (to_tsvector/to_tsquery) and does not work on other adapters.

          To fix this:
            - switch #{model_class}'s database connection to PostgreSQL, or
            - define a custom `#{model_class}.search(query)` scope that works with your \
          adapter; Tramway will use it instead of the built-in pg_search fallback.
        MESSAGE
      end
    end

    # Raised when a Tramway feature depends on a gem that could not be loaded or used, so the
    # developer (or an AI agent) gets a precise, actionable fix instead of a raw NoMethodError
    # or LoadError deep inside the missing gem's call chain.
    class MissingGemError < StandardError
      def initialize(feature:, model_class:, gem_name:, original_error:)
        super(<<~MESSAGE)
          Tramway #{feature} for #{model_class} could not use the `#{gem_name}` gem \
          (#{original_error.class}: #{original_error.message}).

          To fix this:
            - add `gem "#{gem_name}"` to your Gemfile, run `bundle install`, and restart your \
          server (or re-run `bin/rails g tramway:install`, which adds it automatically), or
            - define a custom `#{model_class}.search(query)` scope that does not depend on \
          `#{gem_name}`; Tramway will use it instead of the built-in fallback.
        MESSAGE
      end
    end
  end
end
