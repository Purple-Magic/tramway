# frozen_string_literal: true

require 'tramway/helpers/table_helper'

module Tramway
  module Helpers
    # Provides view-oriented helpers for ActionView
    module ViewsHelper
      include Tramway::Helpers::ComponentHelper
      include Tramway::Helpers::TableHelper

      FORM_SIZES = %i[small medium large].freeze

      def tramway_form_for(object, *, size: :medium, **options, &)
        form_object_class = object.is_a?(Tramway::BaseForm) ? object.class : nil

        form_for(object, *, **options.merge(
          builder: Tramway::Form::Builder,
          size: normalize_form_size(size),
          form_object_class:,
          remote_submit: options[:remote] || false
        ), &)
      end

      def tramway_table(size: :medium, **options, &)
        component 'tramway/table', size: normalize_table_size(size), options:, &
      end

      def tramway_grid(rows:, columns:, outline: false, **options, &)
        component 'tramway/grid', rows:, columns:, outline:, options:, &
      end

      def tramway_card(size: [1, 1], **options, &)
        component 'tramway/grid/card', size:, options:, &
      end

      def tramway_header(headers: nil, columns: nil, **options, &)
        component 'tramway/table/header',
                  headers:,
                  columns:,
                  options:,
                  &
      end

      def tramway_row(**options, &)
        component 'tramway/table/row',
                  cells: options.delete(:cells),
                  href: options.delete(:href),
                  preview: options.delete(:preview),
                  options:,
                  &
      end

      def tramway_cell(**options, &)
        component 'tramway/table/cell', options:, &
      end

      def tramway_button(path: nil, text: nil, method: :get, form_options: {}, **options, &)
        component 'tramway/button', text:, path:, method:, form_options:, color: options.delete(:color),
                                    type: options.delete(:type), size: options.delete(:size),
                                    tag: options.delete(:tag), tooltip: options.delete(:tooltip), options:, &
      end

      def tramway_back_button
        component 'tramway/back_button'
      end

      def tramway_container(id: nil, **options, &)
        if id.present?
          component 'tramway/containers/narrow', id:, options:, &
        else
          component 'tramway/containers/narrow', options:, &
        end
      end

      def tramway_main_container(**options, &)
        options[:id] ||= 'tramway-main-container'
        options[:class] = tramway_main_container_classes(options[:class])
        component 'tramway/containers/main', options:, &
      end

      def tramway_badge(text:, type: nil, color: nil)
        component 'tramway/badge',
                  text:,
                  type:,
                  color:
      end

      def tramway_tooltip(text:, event: :hover, **options, &)
        component 'tramway/tooltip', text:, event:, options:, &
      end

      def tramway_title(text: nil, **options, &)
        component 'tramway/title', text:, options:, &
      end

      def tramway_flash(text:, type:, **options)
        component 'tramway/flash', text:, type:, options:
      end

      def tramway_chat(chat_id:, messages:, message_form:, send_message_path:, **)
        unless messages.all? { _1[:id].present? && _1[:type].present? }
          raise ArgumentError, 'Each message must have :id and :type keys'
        end

        if messages.any? { !_1[:type].to_sym.in?(%i[sent received]) }
          raise ArgumentError, 'Message :type must be either :sent or :received'
        end

        component 'tramway/chat', chat_id:, messages:, message_form:, send_message_path:, **
      end

      private

      def normalize_form_size(size)
        FORM_SIZES.include?(size) ? size : :medium
      end

      def tramway_main_container_classes(value)
        classes = Array(value).flat_map { _1.to_s.split }

        return classes.join(' ') if @tramway_navbar_direction.nil?

        classes = classes.reject { _1.start_with?('md:pl-') || _1.start_with?('md:pr-') }
        classes << 'md:pl-72' if @tramway_navbar_direction == :vertical

        classes.join(' ')
      end
    end
  end
end
