require 'rails/generators/named_base'

module Tramway
  module Generators
    class ModelGenerator < ::Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      class_option :user_role, type: :string, default: 'admin'

      COLLECTION_ATTRIBUTE_LIMIT = 4 # limiting columns in #index table
      ATTRIBUTE_TYPE_MAPPING = {
        date: :date_picker,
        datetime: :date_picker,
        time: :date_picker,
        text: :text,
        string: :string,
        uuid: :string,
        float: :float,
        integer: :integer,
        boolean: :boolean,
      }
      DEFAULT_FIELD_TYPE = :string
      READ_ONLY_ATTRIBUTES = %w[id uuid created_at updated_at]

      def run_decorator_generator
        template(
          'decorator.rb.erb',
          Rails.root.join("app/decorators/#{file_path}_decorator.rb"),
        )
      end

      def run_forms_generator
        template(
          'form.rb.erb',
          Rails.root.join("app/forms/#{user_role}/#{file_path}_form.rb"),
        )
      end

      private

      def user_role
        options[:user_role]
      end

      def attributes
        # TODO: this for model associations, but they probably should be handled differently
        # klass.reflections.keys +

        klass.columns.map(&:name) -
          redundant_attributes
      end

      def form_attributes
        attributes - READ_ONLY_ATTRIBUTES
      end

      def form_type(attribute)
        type = column_type_for_attribute(attribute.to_s)

        if type
          ATTRIBUTE_TYPE_MAPPING.fetch(type, DEFAULT_FIELD_TYPE)
          # else
          #   association_type(attribute)
        end
      end

      def redundant_attributes
        klass.reflections.keys.flat_map do |relationship|
          redundant_attributes_for(relationship)
        end.compact
      end

      def redundant_attributes_for(relationship)
        case association_type(relationship)
        when :polymorphic
          [relationship + '_id', relationship + '_type']
        when :belongs_to
          relationship + '_id'
        end
      end

      def association_type(attribute)
        relationship = klass.reflections[attribute.to_s]
        if relationship.has_one?
          :has_one
        elsif relationship.collection?
          :has_many
        elsif relationship.polymorphic?
          :polymorphic
        else
          :belongs_to
        end
      end

      def column_type_for_attribute(attr)
        column_types(attr)
      end

      def column_types(attr)
        klass.columns.find { |column| column.name == attr }.try(:type)
      end

      def klass
        @klass ||= Object.const_get(class_name)
      end
    end
  end
end
