# frozen_string_literal: true

require 'tramway/configs/entities/route'
require 'tramway/configs/entities/page'

module Tramway
  module Configs
    # Tramway is an entity-based framework
    class Entity < Dry::Struct
      attribute :name, Types::Coercible::String
      attribute? :pages, Types::Array.of(Tramway::Configs::Entities::Page).default([].freeze)
      attribute? :route, Tramway::Configs::Entities::Route

      # Route Struct contains implemented in Tramway CRUD and helpful routes for the entity
      RouteStruct = Struct.new(:index, :show)

      # HumanName Struct contains human names forms for the entity
      HumanNameStruct = Struct.new(:single, :plural)

      def routes
        RouteStruct.new(*route_helper_methods)
      end

      def human_name
        if model_class.present?
          model_name = model_class.model_name.human

          [model_name, pluralized(model_name)]
        else
          [name.capitalize, name.pluralize.capitalize]
        end => single, plural

        HumanNameStruct.new(single, plural)
      end

      def page(name)
        pages.find { |page| page.action == name.to_s }
      end

      private

      def pluralized(model_name)
        local_plural = I18n.t("#{name}.many", scope: 'activerecord.plural.models', default: nil)

        local_plural.presence || model_name.pluralize
      end

      def model_class
        name.classify.constantize
      rescue StandardError
        nil
      end

      def route_helper_methods
        [index_helper_method, show_helper_method]
      end

      def show_helper_method
        underscored_name = name.parameterize

        if set_page?(:show) || route.blank?
          "#{underscored_name}_path"
        else
          route.helper_method_by(underscored_name)
        end => method_name

        method_name
        # route_helper_engine.routes.url_helpers.public_send(method_name)
      end

      def index_helper_method
        underscored_name = name.parameterize.pluralize.underscore

        if set_page?(:index) || route.blank?
          "#{underscored_name}_path"
        else
          route.helper_method_by(underscored_name)
        end => method_name

        method_name
        # route_helper_engine.routes.url_helpers.public_send(method_name)
      end

      def route_helper_engine
        set_page?(:index) ? Tramway::Engine : Rails.application
      end

      alias set_page? page
    end
  end
end
