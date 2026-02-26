# frozen_string_literal: true

module Tramway
  # Searchable module provides a class method `tramway_search` for ActiveRecord models to perform full-text search
  # across all string and text columns using PostgreSQL's full-text search capabilities.
  module Searchable
    extend ActiveSupport::Concern

    class_methods do
      def tramway_search(query)
        return all if query.blank?

        columns_to_search = columns.select { |c| c.type.in?(%i[string text]) }.map(&:name)
        return all if columns_to_search.empty?

        tsvector = columns_to_search.map do |column|
          "coalesce(#{connection.quote_column_name(column)}, '')"
        end.join(" || ' ' || ")

        where(
          Arel.sql("to_tsvector('simple', #{tsvector}) @@ websearch_to_tsquery('simple', ?)"),
          query
        )
      end
    end
  end
end
