# frozen_string_literal: true

require 'tramway/decorators/name_builder'
require 'tramway/decorators/association'
require 'tramway/decorators/collection_decorator'
require 'tramway/helpers/decorate_helper'
require 'tramway/helpers/component_helper'
require 'tramway/utils/render'
require 'tramway/duck_typing'

module Tramway
  # Provides decorate function for Tramway projects
  #
  class BaseDecorator
    include Tramway::Decorators::CollectionDecorators
    include Tramway::Utils::Render
    include Tramway::DuckTyping::ActiveRecordCompatibility
    include Tramway::Helpers::DecorateHelper
    include Tramway::Helpers::ComponentHelper

    attr_reader :object

    def initialize(object)
      @object = object
    end

    class << self
      include Tramway::Helpers::ComponentHelper
      include Tramway::Utils::Render

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

      def list_attributes
        []
      end

      def index_header_content
        nil
      end

      include Tramway::Decorators::AssociationClassMethods
    end

    def to_partial_path
      underscored_class_name = object.class.name.underscore

      "#{underscored_class_name.pluralize}/#{underscored_class_name}"
    end

    def show_path = nil

    # :reek:ManualDispatch { enabled: false } because there is the idea to manual dispatch
    def method_missing(method_name, *, &)
      url_helpers = Rails.application.routes.url_helpers

      if method_name.to_s.end_with?('_path', '_url')
        return url_helpers.public_send(method_name, *, &) if url_helpers.respond_to?(method_name)

        raise NoMethodError, "undefined method `#{method_name}` for #{self}" unless respond_to_missing?(method_name)

      end

      super
    end

    # :reek:BooleanParameter { enabled: false } because it's a part of the duck-typing
    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.end_with?('_path', '_url') || super
    end
  end
end
