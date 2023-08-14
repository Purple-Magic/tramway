# frozen_string_literal: true

require 'tramway/configs/entities/route'

module Tramway
  module Configs
    # Tramway is entity based framework
    #
    class Entity < Dry::Struct
      attribute :name, Types::Coercible::String
      attribute? :route, Tramway::Configs::Entities::Route

      def routes
        OpenStruct.new index: Rails.application.routes.url_helpers.public_send(route_helper_method)
      end

      def human_name
        options = if model_class.present?
                    { single: model_class.model_name.human, plural: model_class.model_name.human.pluralize }
                  else
                    { single: name.capitalize, plural: name.pluralize.capitalize }
                  end
        OpenStruct.new **options
      end

      private

      def model_class
        name.camelize.constantize if defined?(name.camelize.constantize)
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
