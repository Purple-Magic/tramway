# frozen_string_literal: true

module Tramway
  module Helpers
    # Provides view-oriented helpers for ActionView
    module ViewsHelper
      include Tramway::Helpers::ComponentHelper

      FORM_SIZES = %i[small medium large].freeze

      def tramway_form_for(object, *, size: :medium, **options, &)
        form_for(
          object,
          *,
          **options.merge(builder: Tramway::Form::Builder, size: normalize_form_size(size)),
          &
        )
      end

      def tramway_table(**options, &)
        component 'tramway/table', options:, &
      end

      def tramway_header(headers: nil, columns: nil, &)
        component 'tramway/table/header',
                  headers:,
                  columns:,
                  &
      end

      def tramway_row(**options, &)
        component 'tramway/table/row',
                  cells: options.delete(:cells),
                  href: options.delete(:href),
                  options:,
                  &
      end

      def tramway_cell(&)
        component 'tramway/table/cell', &
      end

      def tramway_button(path: nil, text: nil, method: :get, form_options: {}, **options, &)
        component 'tramway/button', text:, path:, method:, form_options:, color: options.delete(:color),
                                    type: options.delete(:type), size: options.delete(:size),
                                    tag: options.delete(:tag), options:, &
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
        component 'tramway/containers/main', options:, &
      end

      def tramway_badge(text:, type: nil, color: nil)
        component 'tramway/badge',
                  text:,
                  type:,
                  color:
      end

      def tramway_title(text: nil, **options, &)
        component 'tramway/title', text:, options:, &
      end

      def tramway_flash(text:, type:, **options)
        component 'tramway/flash', text:, type:, options:
      end

      def tramway_chat(chat_id:, messages:, message_form:, send_message_path:)
        unless messages.all? { _1[:id].present? && _1[:type].present? }
          raise ArgumentError, 'Each message must have :id and :type keys'
        end

        if messages.any? { !_1[:type].to_sym.in?(%i[sent received]) }
          raise ArgumentError, 'Message :type must be either :sent or :received'
        end

        component 'tramway/chat', chat_id:, messages:, message_form:, send_message_path:
      end

      private

      def normalize_form_size(size)
        FORM_SIZES.include?(size) ? size : :medium
      end
    end
  end
end
