# frozen_string_literal: true

module Tramway
  module Decorators
    # Provides functions for collection decorating
    #
    module CollectionDecorators
      module_function

      def decorate_collection(collection:, context:, decorator:)
        collection.map do |item|
          decorator.decorate item, context
        end
      end

      def collection?(object)
        object.class.name.in? ['ActiveRecord::Relation', 'Array']
      end
    end
  end
end
