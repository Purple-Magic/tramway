# frozen_string_literal: true

module Tramway
  module Grid
    # Dashboard-style card for use inside a grid
    class CardComponent < Tramway::BaseComponent
      option :size, optional: true, default: -> { [1, 1] }
      option :options, optional: true, default: -> { {} }

      def card_classes
        [
          'tramway-grid-card',
          options[:class]
        ].compact.join(' ')
      end

      def card_style
        "grid-column: span #{normalized_size.last}; grid-row: span #{normalized_size.first};"
      end

      private

      def normalized_size
        rows, columns = Array(size)

        unless rows.to_i.positive? && columns.to_i.positive?
          raise ArgumentError, 'Grid card size must be a two-item array of positive integers.'
        end

        [rows.to_i, columns.to_i]
      end
    end
  end
end
