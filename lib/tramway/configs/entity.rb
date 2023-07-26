# frozen_string_literal: true

module Tramway
  module Configs
    # Tramway is entity based framework
    #
    class Entity
      attr_reader :name

      def initialize(name:)
        @name = name.to_s
      end

      def routes
        underscored_name = name.parameterize.pluralize.underscore

        OpenStruct.new index: Rails.application.routes.url_helpers.public_send("#{underscored_name}_path")
      end

      def human_name
        OpenStruct.new single: name.capitalize, plural: name.pluralize.capitalize
      end
    end
  end
end
