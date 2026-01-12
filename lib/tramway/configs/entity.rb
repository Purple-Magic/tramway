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
      ACTIONS = %i[index show new create edit update].freeze
      RouteStruct = Struct.new(*ACTIONS)

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

      def show_helper_method
        build_helper_method(name, route:, namespace:, plural: false)
      end

      def index_helper_method
        build_helper_method(name, route:, namespace:, plural: true)
      end

      def new_helper_method
        build_helper_method(name, route:, namespace:, plural: false, action: :new)
      end

      def create_helper_method
        build_helper_method(name, route:, namespace:, plural: true)
      end

      def edit_helper_method
        build_helper_method(name, route:, namespace:, plural: false, action: :edit)
      end

      def update_helper_method
        build_helper_method(name, route:, namespace:, plural: false)
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
        ACTIONS.map do |action|
          cond = case action
                 when :index, :show   then page(action).present?
                 when :new, :create   then page(:create).present?
                 when :edit, :update  then page(:update).present?
                 end

          send("#{action}_helper_method") if cond
        end
      end

      def build_helper_method(base_name, route: nil, namespace: nil, plural: false, action: nil)
        if plural
          base_name.to_s.parameterize.underscore.pluralize
        else
          base_name.to_s.parameterize.underscore
        end => underscored

        method_name = route.present? ? route.helper_method_by(underscored) : "#{underscored}_path"

        namespaced_method_name = namespace.present? ? "#{namespace}_#{method_name}" : method_name

        action.present? ? "#{action}_#{namespaced_method_name}" : namespaced_method_name
      end

      def route_helper_engine
        set_page?(:index) ? Tramway::Engine : Rails.application
      end

      alias set_page? page
    end
  end
end
