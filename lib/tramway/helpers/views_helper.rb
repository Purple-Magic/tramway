# frozen_string_literal: true

module Tramway
  module Helpers
    # Provides view-oriented helpers for ActionView
    module ViewsHelper
      def tramway_form_for(object, *, size: :middle, **options, &)
        form_for(
          object,
          *,
          **options.merge(builder: Tailwinds::Form::Builder, size:),
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

      def tramway_button(path:, text: nil, method: :get, **options)
        component 'tailwinds/button',
                  text:,
                  path:,
                  method:,
                  color: options.delete(:color),
                  type: options.delete(:type),
                  size: options.delete(:size),
                  options:
      end

      def tramway_back_button
        component 'tailwinds/back_button'
      end

      def tramway_container(id: nil, &)
        if id.present?
          component 'tailwinds/containers/narrow', id: id, &
        else
          component 'tailwinds/containers/narrow', &
        end
      end
    end
  end
end
