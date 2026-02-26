# frozen_string_literal: true

module Tramway
  # Searchable module provides a class method `tramway_search` for ActiveRecord models to perform full-text search
  # across all string and text columns using PostgreSQL's full-text search capabilities.
  module Searchable
    extend ActiveSupport::Concern

    class_methods do
      def tramway_search(query)
        tokens = search_tokens(query)
        columns_to_search = searchable_column_names

        return all if tokens.empty? || columns_to_search.empty?

        where(
          Arel.sql("to_tsvector('simple', #{tsvector_expression(columns_to_search)}) @@ to_tsquery('simple', ?)"),
          tsquery_expression(tokens)
        )
      end

      private

      def search_tokens(query)
        query.to_s.scan(/[[:alnum:]]+/)
      end

      def searchable_column_names
        columns.select { |column| column.type.in?(%i[string text]) }.map(&:name)
      end

      def tsvector_expression(column_names)
        column_names.map do |column_name|
          "coalesce(#{connection.quote_column_name(column_name)}, '')"
        end.join(" || ' ' || ")
      end

      def tsquery_expression(tokens)
        tokens.map { |token| "#{token}:*" }.join(' & ')
      end
    end
  end
end
