# frozen_string_literal: true

module Tramway
  module ApplicationForms
    module PropertiesObjectHelper
      def form_properties(**args)
        @form_properties = args
      end

      def properties
        @form_properties ||= {}
        yaml_config_file_path = Rails.root.join('app', 'forms', "#{self.class.name.underscore}.yml")

        return @form_properties unless File.exist? yaml_config_file_path

        @form_properties.deep_merge YAML.load_file(yaml_config_file_path).deep_symbolize_keys
      end
    end
  end
end
