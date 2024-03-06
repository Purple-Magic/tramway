# frozen_string_literal: true

require 'tramway/decorators/collection_decorator'
require 'tramway/utils/render'

module Tramway
  # Provides decorate function for Tramway projects
  #
  class BaseDecorator
    include Tramway::Decorators::CollectionDecorators
    include Tramway::Utils::Render

    attr_reader :object

    def initialize(object)
      @object = object
    end

    class << self
      # :reek:NilCheck { enabled: false } because checking for nil is not a type-checking issue but business logic
      def decorate(object_or_array)
        return if object_or_array.nil?

        if Tramway::Decorators::CollectionDecorators.collection?(object_or_array)
          Tramway::Decorators::CollectionDecorators.decorate_collection(
            collection: object_or_array,
            decorator: self
          )
        else
          new(object_or_array)
        end
      end

      def delegate_attributes(*args)
        args.each do |attribute|
          delegate attribute, to: :object
        end
      end
    end

    delegate_attributes :id

    def to_partial_path
      underscored_class_name = object.class.name.underscore

      "#{underscored_class_name.pluralize}/#{underscored_class_name}"
    end
  end
end
