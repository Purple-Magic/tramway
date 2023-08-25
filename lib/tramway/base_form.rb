# frozen_string_literal: true

module Tramway
  # Provides form object for Tramway
  #
  class BaseForm
    attr_reader :object

    [ :model_name, :to_key, :to_model, :errors, :attributes ].each do |method_name|
      delegate method_name, to: :object
    end

    def initialize(object)
      @object = object
    end

    class << self
      def property(attribute)
        @properties ||= []
        @properties << attribute

        delegate attribute, to: :object
      end

      def properties(*attributes)
        attributes.each do |attribute|
          property(attribute)
        end
      end
    end

    def submit(params)
      self.class.properties.each do |attribute|
        public_send("#{attribute}=", params[attribute])
      end

      object.save
    end

    def method_missing(method_name, *args)
      if method_name.to_s.end_with?('=')
        variable_name = method_name.to_s.chomp('=')

        define_method method_name do |value|
          object.public_send method_name, value
        end

        public_send(method_name, *args)
      else
        super
      end
    end
  end
end
