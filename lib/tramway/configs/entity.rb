# frozen_string_literal: true

require 'tramway/configs/entities/route'

module Tramway
  module Configs
    # Tramway is an entity-based framework
    class Entity < Dry::Struct
      attribute :name, Types::Coercible::String
      attribute? :route, Tramway::Configs::Entities::Route

      # Route Struct contains implemented in Tramway CRUD and helpful routes for the entity
      RouteStruct = Struct.new(:index)

      # HumanNameStruct contains human names forms for the entity
      HumanNameStruct = Struct.new(:single, :plural)

      def routes
        RouteStruct.new(Rails.application.routes.url_helpers.public_send(route_helper_method))
      end

      def human_name
        single, plural = if model_class.present?
                           model_name = model_class.model_name.human
                           [model_name, model_name.pluralize]
                         else
                           [name.capitalize, name.pluralize.capitalize]
                         end

        HumanNameStruct.new(single, plural)
      end

      private

      def model_class
        name.camelize.constantize
      rescue StandardError
        nil
      end

      def route_helper_method
        underscored_name = name.parameterize.pluralize.underscore

        if route.present?
          route.helper_method_by(underscored_name)
        else
          "#{underscored_name}_path"
        end
      end
    end
  end
end
