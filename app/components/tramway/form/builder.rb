# frozen_string_literal: true

require 'tramway/utils/field'

module Tramway
  module Form
    # Provides Tailwind-styled forms
    # rubocop:disable Metrics/ClassLength
    class Builder < Tramway::Views::FormBuilder
      include Tramway::Utils::Field
      include Tramway::ColorsMethods

      def initialize(object_name, object, template, options)
        @horizontal = options[:horizontal] || false
        @remote = options[:remote_submit] || false

        options.merge!(class: [options[:class], 'flex flex-row items-center gap-2'].compact.join(' ')) if @horizontal

        @form_object_class = options[:form_object_class]

        if form_object(object)
          super(object_name, form_object(object), template, options)
        else
          super
        end

        @form_size = options[:size] || options['size'] || :medium
      end

      def common_field(component_name, input_method, attribute, **options, &)
        sanitized_options = sanitize_options(options)

        component_class = "Tramway::Form::#{component_name.to_s.camelize}Component".constantize

        render(component_class.new(
                 input: input(input_method),
                 value: get_value(attribute, sanitized_options),
                 **default_options(attribute, sanitized_options)
               ),
               &)
      end

      def text_field(attribute, **, &)
        common_field(:text_field, :text_field, attribute, **, &)
      end

      def email_field(attribute, **, &)
        common_field(:text_field, :email_field, attribute, **, &)
      end

      def number_field(attribute, **, &)
        common_field(:number_field, :number_field, attribute, **, &)
      end

      def text_area(attribute, **, &)
        common_field(:text_area, :text_area, attribute, **, &)
      end

      def password_field(attribute, **options, &)
        sanitized_options = sanitize_options(options)

        render(Tramway::Form::TextFieldComponent.new(
                 input: input(:password_field),
                 **default_options(attribute, sanitized_options)
               ), &)
      end

      def date_field(attribute, **, &)
        common_field(:date_field, :date_field, attribute, **, &)
      end

      def datetime_field(attribute, **, &)
        common_field(:datetime_field, :datetime_field, attribute, **, &)
      end

      def time_field(attribute, **, &)
        common_field(:time_field, :time_field, attribute, **, &)
      end

      def file_field(attribute, **options, &)
        sanitized_options = sanitize_options(options)
        input = super(attribute, **sanitized_options.merge(class: :hidden))

        render(Tramway::Form::FileFieldComponent.new(input:, **default_options(attribute, sanitized_options)), &)
      end

      def check_box(attribute, **, &)
        common_field(:checkbox, :check_box, attribute, **, &)
      end

      def select(attribute, collection, **options, &)
        if options[:multiple] || options[:autocomplete]
          tramway_select(attribute, collection, **options, &)
        else
          default_select(attribute, collection, **options, &)
        end
      end

      def submit(action, **options, &)
        sanitized_options = sanitize_options(options)

        render(
          Tramway::ButtonComponent.new(
            text: action,
            size: form_size,
            type: :will,
            options: sanitized_options.merge(name: :commit, type: :submit)
          ),
          &
        )
      end

      private

      attr_reader :form_size

      def default_select(attribute, collection, **options, &)
        sanitized_options = sanitize_options(options)

        render(Tramway::Form::SelectComponent.new(
                 input: input(:select),
                 value: sanitized_options[:selected] || object.public_send(attribute),
                 collection: explicitly_add_blank_option(collection, sanitized_options),
                 **default_options(attribute, sanitized_options)
               ), &)
      end

      def tramway_select(attribute, collection, **options, &)
        sanitized_options = sanitize_options(options)

        render(Tramway::Form::TramwaySelectComponent.new(
                 input: input(:text_field),
                 value: sanitized_options[:value] || sanitized_options[:selected] || object.public_send(attribute),
                 collection:,
                 multiple: options[:multiple],
                 autocomplete: options[:autocomplete],
                 **default_options(attribute, sanitized_options)
               ), &)
      end

      def input(method_name)
        unbound_method = self.class.superclass.instance_method(method_name)
        unbound_method.bind(self)
      end

      def form_object(obj = nil)
        return obj if obj.is_a?(Tramway::BaseForm)
        return object if object.is_a?(Tramway::BaseForm)

        @form_object_class&.new(obj || object)
      end

      def get_value(attribute, options)
        return options[:value] if options.has_key?(:value)

        if form_object.present? && !form_object&.public_send(attribute).nil?
          return form_object&.public_send(attribute)
        end

        if object.present? && !object.respond_to?(attribute)
          form_object_part = form_object.present? ? "#{form_object.class} or " : ''

          raise ArgumentError, "Neither form object nor object respond to #{attribute}. You should define #{attribute} method in #{form_object_part}#{object.class}"
        end

        return if object.blank?

        object.public_send(attribute)
      end

      def default_options(attribute, options)
        options.merge!(horizontal: true) if @horizontal
        options.merge!(onchange: 'this.form.requestSubmit()') if @remote

        {
          attribute:,
          label: label_build(attribute, options),
          for: options[:id].presence || for_id(attribute),
          options: options,
          size: form_size,
        }
      end

      def label_build(attribute, options)
        label_option = options[:label]

        label_option.nil? ? attribute.to_s.humanize : label_option
      end

      def for_id(attribute)
        "#{object_name}_#{attribute}"
      end

      def sanitize_options(options)
        options.dup.tap do |opts|
          %i[size multiple autocomplete].each do |key|
            opts.delete(key)
            opts.delete(key.to_s)
          end
        end
      end

      # REMOVE IT. WE MUST UNDERSTAND WHY INCLUDE_BLANK DOES NOT WORK
      def explicitly_add_blank_option(collection, options)
        if options[:include_blank]
          collection = collection.to_a if collection.is_a? Hash

          collection.unshift([nil, ''])
        else
          collection
        end
      end
    end
    # rubocop:enable Metrics/ClassLength
  end
end
