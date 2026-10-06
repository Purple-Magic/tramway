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

    # Raised when `params[:filter]` on an entities#index page does not match any of the
    # filters declared for that page in the Tramway config, so the developer (or the user
    # following a crafted link) gets a clear explanation instead of a raw NoMethodError from
    # calling an arbitrary, possibly non-existent scope.
    class InvalidFilterError < StandardError
      def initialize(filter:, available_filters:, model_class:)
        super(<<~MESSAGE)
          Tramway received an unknown filter "#{filter}" for #{model_class} on the \
          entities#index page.

          Available filters: #{available_filters.join(', ')}.

          To fix this:
            - pass one of the available filters above in `params[:filter]`, or
            - add `:#{filter}` to this entity's `filters:` list for the `:index` page in your \
          Tramway config if it should be selectable.
        MESSAGE
      end
    end

    # Raised when `Tramway.config.plugins` references a plugin name that was never registered
    # via `Tramway::Plugins.register`, so the developer gets a clear explanation instead of a
    # raw NoMethodError/KeyError deep inside the plugin config collection.
    class UnknownPluginError < StandardError
      def initialize(name:, available:)
        super(<<~MESSAGE)
          Tramway received an unknown plugin "#{name}".

          Available plugins: #{available.any? ? available.join(', ') : '(none registered)'}.

          To fix this:
            - use one of the available plugins above in `Tramway.config.plugins`, or
            - register a custom plugin via `Tramway::Plugins.register(YourPluginClass)` before \
          referencing it in the config.
        MESSAGE
      end
    end

    # Raised when a Tramway plugin depends on a gem that is not installed in the host
    # application, so the developer gets a precise, actionable fix instead of a raw
    # LoadError/NameError deep inside the plugin's controllers.
    class MissingPluginDependencyError < StandardError
      def initialize(plugin:, gem_name:, original_error:)
        super(<<~MESSAGE)
          The Tramway "#{plugin}" plugin requires the `#{gem_name}` gem, but it could not be \
          loaded (#{original_error.class}: #{original_error.message}).

          To fix this:
            - add `gem "#{gem_name}"` to your Gemfile and run `bundle install`, then restart \
          your server, or
            - remove `:#{plugin}` from `Tramway.config.plugins` if you do not want to use this \
          plugin.
        MESSAGE
      end
    end
  end
end
