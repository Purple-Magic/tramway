# frozen_string_literal: true

require 'tramway/decorators/collection_decorator'

module Tramway
  # Provides decorate function for Tramway projects
  #
  class BaseDecorator
    include Tramway::Decorators::CollectionDecorators

    attr_reader :object, :context

    def initialize(object, context)
      @object = object
      @context = context
    end

    def render(*args)
      context.render(*args, layout: false)
    end

    class << self
      def decorate(object_or_array, context)
        if Tramway::Decorators::CollectionDecorators.collection?(object_or_array)
          Tramway::Decorators::CollectionDecorators.decorate_collection(
            collection: object_or_array,
            context:,
            decorator: self
          )
        else
          new(object_or_array, context)
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

    def to_param
      id.to_s
    end
  end
end
