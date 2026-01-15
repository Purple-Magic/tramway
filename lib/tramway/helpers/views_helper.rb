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
          **options.merge(builder: Tailwinds::Form::Builder, size: normalize_form_size(size)),
          &
        )
      end

      def tramway_table(**options, &)
        component 'tailwinds/table', options:, &
      end

      def tramway_header(headers: nil, columns: nil, &)
        component 'tailwinds/table/header',
                  headers:,
                  columns:,
                  &
      end

      def tramway_row(**options, &)
        component 'tailwinds/table/row',
                  cells: options.delete(:cells),
                  href: options.delete(:href),
                  options:,
                  &
      end

      def tramway_cell(&)
        component 'tailwinds/table/cell', &
      end

      # rubocop:disable Metrics/ParameterLists
      def tramway_button(path: nil, text: nil, method: :get, link: false, form_options: {}, **options, &)
        component 'tailwinds/button', text:, path:, method:, link:, form_options:, color: options.delete(:color),
                                      type: options.delete(:type), size: options.delete(:size), options:, &
      end
      # rubocop:enable Metrics/ParameterLists

      def tramway_back_button
        component 'tailwinds/back_button'
      end

      def tramway_container(id: nil, **options, &)
        if id.present?
          component 'tailwinds/containers/narrow', id:, options:, &
        else
          component 'tailwinds/containers/narrow', options:, &
        end
      end

      def tramway_main_container(**options, &)
        component 'tailwinds/containers/main', options:, &
      end

      def tramway_badge(text:, type: nil, color: nil)
        component 'tailwinds/badge',
                  text:,
                  type:,
                  color:
      end

      def tramway_title(text: nil, &)
        component 'tailwinds/title', text:, &
      end

      def tramway_flash(text:, type:, **options)
        component 'tailwinds/flash', text:, type:, options:
      end

      private

      def normalize_form_size(size)
        FORM_SIZES.include?(size) ? size : :medium
      end
    end
  end
end
