# frozen_string_literal: true

require 'tramway/forms/properties'
require 'tramway/forms/normalizations'

module Tramway
  # Provides form object for Tramway
  #
  class BaseForm
    attr_reader :object

    %i[model_name to_key to_model errors attributes].each do |method_name|
      delegate method_name, to: :object
    end

    def initialize(object)
      @object = object

      self.class.delegate object.class.primary_key, to: :object
    end

    class << self
      def inherited(subclass)
        subclass.instance_variable_set(:@properties, [])
        subclass.instance_variable_set(:@normalizations, __ancestor_normalizations)

        super
      end

      include Tramway::Forms::Properties
      include Tramway::Forms::Normalizations
    end

    def submit(params)
      __submit params

      object.save.tap do
        __object
      end
    end

    def submit!(params)
      __submit params

      object.save!.tap do
        __object
      end
    end

    def method_missing(method_name, *args)
      if method_name.to_s.end_with?('=') && args.count == 1
        object.public_send(method_name, args.first)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.end_with?('=') || super
    end

    private

    def __apply_normalizations(params)
      self.class.normalizations.each do |attribute, proc|
        public_send("#{attribute}=", proc.call(params[attribute])) if params.key?(attribute)
      end
    end

    def __submit(params)
      __apply_normalizations(params)
      self.class.properties.each do |attribute|
        public_send("#{attribute}=", params[attribute]) if params.keys.include? attribute.to_s
      end
    end

    def __object
      object.persisted? ? object.reload : object
    end
  end
end
