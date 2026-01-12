# frozen_string_literal: true

require 'tramway/decorators/name_builder'
require 'tramway/decorators/association'
require 'tramway/decorators/collection_decorator'
require 'tramway/helpers/decorate_helper'
require 'tramway/helpers/component_helper'
require 'tramway/helpers/views_helper'
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
    include Tramway::Helpers::ViewsHelper

    attr_reader :object, :view_context

    def initialize(object)
      @object = object
    end

    def with(view_context:)
      @view_context = view_context

      self
    end

    class << self
      include Tramway::Helpers::ComponentHelper
      include Tramway::Utils::Render

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

      def index_attributes
        []
      end

      def index_header_content
        nil
      end

      def table_headers(entity)
        headers = index_attributes.map do |attribute|
          entity.model_class.human_attribute_name(attribute)
        end

        headers += ['Actions'] if entity&.page(:update).present? || entity&.page(:destroy).present?

        headers
      end

      include Tramway::Decorators::AssociationClassMethods
    end

    def to_partial_path
      underscored_class_name = object.class.name.underscore

      "#{underscored_class_name.pluralize}/#{underscored_class_name}"
    end

    def show_path = nil

    def show_attributes
      []
    end

    def show_associations
      []
    end

    def show_header_content
      nil
    end

    def method_missing(method_name, *, &)
      url_helpers = Rails.application.routes.url_helpers

      if method_name.to_s.end_with?('_path', '_url')
        return url_helpers.public_send(method_name, *, &) if url_helpers.respond_to?(method_name)

        raise NoMethodError, "undefined method `#{method_name}` for #{self}" unless respond_to_missing?(method_name)

      end

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.end_with?('_path', '_url') || super
    end
  end
end
