# frozen_string_literal: true

module Tramway
  module Decorators
    # Provides functions for collection decorating
    #
    module CollectionDecorators
      module_function

      def decorate_collection(collection:, decorator:)
        collection.map do |item|
          decorator.decorate item
        end
      end

      def collection?(object)
        object.is_a?(Array) || object.is_a?(ActiveRecord::Relation)
      end
    end
  end
end
