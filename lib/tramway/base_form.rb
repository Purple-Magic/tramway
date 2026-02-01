# frozen_string_literal: true

require 'tramway/forms/properties'
require 'tramway/forms/normalizations'
require 'tramway/forms/validations'
require 'tramway/forms/fields'
require 'tramway/duck_typing'

module Tramway
  # Provides form object for Tramway
  #
  class BaseForm
    include Tramway::Forms::Properties
    include Tramway::Forms::Fields
    include Tramway::Forms::Normalizations
    include Tramway::Forms::Validations
    include Tramway::DuckTyping::ActiveRecordCompatibility

    attr_reader :object, :initial_object

    def initialize(object)
      @object = object
      @initial_object = object.dup

      self.class.delegate object.class.primary_key, to: :object
    end

    class << self
      def inherited(subclass)
        __initialize_properties subclass
        __initialize_normalizations subclass
        __initialize_validations subclass
        __initialize_fields subclass

        super
      end
    end

    def submit(params)
      __submit params

      return false if object.errors.any?

      object.save.tap do
        __object
      end
    end

    def submit!(params)
      __submit params

      raise ActiveRecord::RecordInvalid, object if object.errors.any?

      object.save!.tap do
        __object
      end
    end

    def assign(params)
      __submit params
    end

    def method_missing(method_name, *args)
      if method_name.to_s.end_with?('=') && args.one?
        object.public_send(method_name, args.first)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.end_with?('=') || super
    end

    delegate :to_model, to: :object
    delegate :new_record?, to: :object

    private

    def __submit(params)
      normalized_params = __apply_normalizations(params)

      __apply_properties normalized_params
      __apply_validations normalized_params
    end

    def __object
      object.persisted? ? object.reload : object
    end
  end
end
