# frozen_string_literal: true

require 'tramway/configs/entities/route'

module Tramway
  module Configs
    # Tramway is an entity-based framework
    class Entity < Dry::Struct
      attribute :name, Types::Coercible::String
      attribute? :pages, Types::Array.of(Types::Symbol).default([].freeze)
      attribute? :route, Tramway::Configs::Entities::Route

      # Route Struct contains implemented in Tramway CRUD and helpful routes for the entity
      RouteStruct = Struct.new(:index)

      # HumanNameStruct contains human names forms for the entity
      HumanNameStruct = Struct.new(:single, :plural)

      def routes
        RouteStruct.new(route_helper_method)
      end

      def human_name
        single, plural = if model_class.present?
                           model_name = model_class.model_name.human
                           [model_name, pluralized(model_name)]
                         else
                           [name.capitalize, name.pluralize.capitalize]
                         end

        HumanNameStruct.new(single, plural)
      end

      private

      def pluralized(model_name)
        local_plural = I18n.t("#{name}.many", scope: 'activerecord.plural.models')

        local_plural.present? ? local_plural : model_name.pluralize
      end

      def model_class
        name.classify.constantize
      rescue StandardError
        nil
      end

      def route_helper_method
        underscored_name = name.parameterize.pluralize.underscore

        method_name = if pages.include?(:index) || route.blank?
                        "#{underscored_name}_path"
                      else
                        route.helper_method_by(underscored_name)
                      end

        route_helper_engine.routes.url_helpers.public_send(method_name)
      end

      def route_helper_engine
        pages.include?(:index) ? Tramway::Engine : Rails.application
      end
    end
  end
end
