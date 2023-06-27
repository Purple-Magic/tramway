# frozen_string_literal: true

require 'tramway/decorators/collection_decorator'

module Tramway
  # Provides decorate function for Tramway projects
  #
  class BaseDecorator
    include Tramway::Decorators::CollectionDecorators
    include ActionView::Context
    include ActionView::Helpers

    attr_reader :object, :context

    def initialize(object, context)
      @object = object
      @context = context
    end

    def render(*args)
      context.render(*args, layout: false)
    end

    class << self
      include Tramway::Decorators::CollectionDecorators

      def decorate(object_or_array, context)
        if object_or_array.is_a? ActiveRecord::Relation
          decorate_collection(collection: object_or_array, context:)
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
