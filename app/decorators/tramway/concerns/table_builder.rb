# frozen_string_literal: true

module Tramway
  module Concerns
    module TableBuilder
      def table(**options, &block)
        content_tag(:table, class: 'table table-bordered table-striped', **options) do
          yield if block
        end
      end

      def thead(**options, &block)
        content_tag(:thead, **options) do
          yield if block
        end
      end

      def th(**options, &block)
        content_tag(:th, **options) do
          yield if block
        end
      end

      def td(**options, &block)
        content_tag(:td, **options) do
          yield if block
        end
      end

      def tr(**options, &block)
        content_tag(:tr, **options) do
          yield if block
        end
      end
    end
  end
end
