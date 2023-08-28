# frozen_string_literal: true

require 'dry-initializer'

module Tramway
  # Provides form object for Tramway
  #
  class BaseForm
    extend Dry::Initializer
    param :object

    [ :model_name, :to_key, :to_model, :errors, :attributes ].each do |method_name|
      delegate method_name, to: :object
    end

    def initialize(object)
      @object = object
    end

    class << self
      def property(attribute, proc_obj = nil)
        @properties ||= []
        @properties << attribute

        if proc_obj.present?
          option attribute, proc_obj
        else
          option attribute
        end

        delegate attribute, to: :object
      end

      def properties(*attributes)
        if attributes.any?
          attributes.each do |attribute|
            property(attribute)
          end
        else
          @properties || []
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
      if method_name.to_s.end_with?('=') && args.count == 1
        object.public_send method_name, args.first
      else
        super
      end
    end
  end
end
