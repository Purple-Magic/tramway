# frozen_string_literal: true

module Tramway
  module Configs
    # Tramway is entity based framework
    #
    class Entity
      attr_reader :name

      def initialize(name:)
        @name = name
      end

      def routes
        OpenStruct.new index: Rails.application.routes.url_helpers.public_send("#{name.to_s.pluralize}_path")
      end

      def human_name
        OpenStruct.new single: name.to_s.capitalize, plural: name.to_s.pluralize.capitalize
      end
    end
  end
end
