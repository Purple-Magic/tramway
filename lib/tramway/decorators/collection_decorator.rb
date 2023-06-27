# frozen_string_literal: true

module Tramway
  module Decorators
    # Provides functions for collection decorating
    #
    module CollectionDecorators
      def decorate_collection(collection:, context:)
        collection.map do |item|
          decorate item, context
        end
      end
    end
  end
end
