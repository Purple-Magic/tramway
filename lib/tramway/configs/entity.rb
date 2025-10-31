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
      attribute? :namespace, Types::Coercible::String

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
        %i[index show].map do |action|
          page(action).present? ? send("#{action}_helper_method") : nil
        end.compact
      end

      def build_helper_method(base_name, route: nil, namespace: nil, plural: false)
        if plural
          base_name.to_s.parameterize.underscore.pluralize
        else
          base_name.to_s.parameterize.underscore
        end => underscored

        method_name = route.present? ? route.helper_method_by(underscored) : "#{underscored}_path"
        namespace.present? ? "#{namespace}_#{method_name}" : method_name
      end

      def show_helper_method
        build_helper_method(name, route:, namespace:, plural: false)
      end

      def index_helper_method
        build_helper_method(name, route:, namespace:, plural: true)
      end

      def route_helper_engine
        set_page?(:index) ? Tramway::Engine : Rails.application
      end

      alias set_page? page
    end
  end
end
