# frozen_string_literal: true

require 'tramway/pg_searchable'

module Tramway
  # Searchable module provides a class method `tramway_search` for ActiveRecord models to
  # perform a generic search across all string and text columns, using the `pg_search` gem.
  # It is the fallback Tramway::EntitiesController uses when a model does not define its
  # own `.search` scope. See Tramway::PgSearchable for the PostgreSQL requirement.
  module Searchable
    extend ActiveSupport::Concern

    class_methods do
      def tramway_search(query)
        return all if query.blank?

        Tramway::PgSearchable.call(self, query)
      end

      def searchable_column_names
        columns.select { |column| column.type.in?(%i[string text]) }.map(&:name)
      end
    end
  end
end
