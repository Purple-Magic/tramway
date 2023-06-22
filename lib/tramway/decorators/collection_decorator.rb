# frozen_string_literal: true

module Tramway
  module Decorators
    # Provides functions for collection decorating
    #
    module CollectionDecorators
      def decorate_collection(collection:)
        collection.map do |item|
          decorate item
        end
      end
    end
  end
end
