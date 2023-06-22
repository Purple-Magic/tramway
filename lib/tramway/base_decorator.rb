# frozen_string_literal: true

require 'tramway/decorators/collection_decorator'

module Tramway
  # Provides decorate function for Tramway projects
  #
  class BaseDecorator
    include Tramway::Decorators::CollectionDecorators

    attr_reader :object

    def initialize(object)
      @object = object
    end

    class << self
      include Tramway::Decorators::CollectionDecorators

      def decorate(object_or_array)
        if object_or_array.is_a? ActiveRecord::Relation
          decorate_collection object_or_array
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

    def to_partial_path
      underscored_class_name = object.class.name.underscore

      "#{underscored_class_name.pluralize}/#{underscored_class_name}"
    end

    def to_param
      id.to_s
    end
  end
end
