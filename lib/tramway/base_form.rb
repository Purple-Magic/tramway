# frozen_string_literal: true

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
      attr_reader :normalizations

      def normalizes(attribute, with:)
        @normalizations ||= {}
        @normalizations[attribute] = with
      end

      def apply_normalizations(params)
        @normalizations.each do |attribute, proc|
          params[attribute] = proc.call(params[attribute]) if params.key?(attribute)
        end
      end

      def inherited(subclass)
        subclass.instance_variable_set(:@properties, [])

        super
      end

      def property(attribute)
        @properties << attribute

        delegate attribute, to: :object
      end

      def properties(*attributes)
        attributes.any? ? __set_properties(attributes) : __properties
      end

      def __set_properties(attributes)
        attributes.each do |attribute|
          property(attribute)
        end
      end

      def __properties
        (__ancestor_properties + @properties).uniq
      end

      # :reek:ManualDispatch { enabled: false }
      def __ancestor_properties(klass = superclass)
        superklass = klass.superclass

        return [] unless superklass.respond_to?(:properties)

        klass.properties + __ancestor_properties(superklass)
      end
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

    def __submit(params)
      self.class.apply_normalizations(params)
      self.class.properties.each do |attribute|
        public_send("#{attribute}=", params[attribute]) if params.keys.include? attribute.to_s
      end
    end

    def __object
      object.persisted? ? object.reload : object
    end
  end
end
