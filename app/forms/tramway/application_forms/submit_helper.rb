# frozen_string_literal: true

module Tramway
  module ApplicationForms
    module SubmitHelper
      def submit(params)
        if params
          params.each { |key, value| send("#{key}=", value) }
          result = save
          result.tap do
            collecting_associations_errors unless result
          end
        else
          Tramway::Error.raise_error(:tramway, :application_form, :submit, :params_should_not_be_nil)
        end
      end

      def save
        model.save
      rescue ArgumentError => e
        Tramway::Error.raise_error :tramway, :application_form, :save, :argument_error, message: e.message
      rescue StandardError => e
        raise e unless e.try :name

        Tramway::Error.raise_error :tramway, :application_form, :save, :looks_like_you_have_method,
                                   method_name: e.name.to_s.gsub('=', ''), model_class: model.class, class_name: self.class
      end
    end
  end
end
