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
    end

    class << self
      def property(attribute, _proc_obj = nil)
        @properties ||= []
        @properties << attribute

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
      __submit params

      object.save.tap do
        object.reload
      end
    end

    def submit!(params)
      __submit params

      object.save!.tap do
        object.reload
      end
    end

    def respond_to_missing?(method_name)
      return true if method_name.to_s.end_with?('=')

      super
    end

    def method_missing(method_name, *args)
      if method_name.to_s.end_with?('=') && args.count == 1
        object.public_send(method_name, args.first)
      else
        super
      end
    end

    private

    def __submit(params)
      self.class.properties.each do |attribute|
        public_send("#{attribute}=", params[attribute])
      end
    end
  end
end
