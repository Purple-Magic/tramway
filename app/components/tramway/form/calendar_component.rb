# frozen_string_literal: true

module Tramway
  module Form
    # Calendar picker component for tramway_form_for
    class CalendarComponent < Tramway::BaseComponent
      class SelectionForm
        include ActiveModel::Model

        attr_accessor :month, :year
      end

      DAYS_IN_WEEK = 7
      YEAR_RANGE_OFFSET = 5

      option :year, optional: true
      option :month, optional: true
      option :selected_dates, optional: true, default: -> { [] }
      option :action, optional: true

      def month_options
        Date::MONTHNAMES.compact.each_with_index.map do |name, index|
          [name, index + 1]
        end
      end

      def day_names
        Date::ABBR_DAYNAMES
      end

      def year_options
        (displayed_year - YEAR_RANGE_OFFSET..displayed_year + YEAR_RANGE_OFFSET).to_a
      end

      def displayed_month
        resolved_month
      end

      def displayed_year
        resolved_year
      end

      def form_action
        request.path
      end

      def selection_form
        SelectionForm.new(month: displayed_month, year: displayed_year)
      end

      def preserved_query_params
        request.query_parameters.except('month', 'year')
      end

      def hidden_query_fields
        flatten_params(preserved_query_params)
      end

      def date_action?
        action.present?
      end

      def date_action_path
        action.fetch(:path)
      end

      def date_action_method
        action.fetch(:method, :get).to_sym
      end

      def hidden_action_fields(date)
        flatten_params(action_params_with_date(date))
      end

      def weeks
        calendar_days.each_slice(DAYS_IN_WEEK).to_a
      end

      def current_month?(date)
        date.month == month_date.month
      end

      def selected_date?(date)
        normalized_selected_dates.include?(date)
      end

      def date_classes(date)
        classes = %w[px-3 py-3 text-center align-middle]

        if selected_date?(date)
          classes.concat(%w[rounded-md bg-zinc-50 text-zinc-950])
        elsif current_month?(date)
          classes << 'text-zinc-50'
        else
          classes << 'text-zinc-500'
        end

        classes
      end

      private

      def flatten_params(value, prefix = nil)
        case value
        when Hash
          value.flat_map do |key, nested_value|
            nested_prefix = prefix.present? ? "#{prefix}[#{key}]" : key.to_s
            flatten_params(nested_value, nested_prefix)
          end
        when Array
          value.flat_map do |nested_value|
            flatten_params(nested_value, "#{prefix}[]")
          end
        else
          [{ name: prefix, value: }]
        end
      end

      def calendar_days
        (calendar_start..calendar_end).to_a
      end

      def calendar_start
        month_date.beginning_of_month - month_date.beginning_of_month.wday
      end

      def calendar_end
        month_end = month_date.end_of_month

        month_end + (DAYS_IN_WEEK - month_end.wday - 1)
      end

      def month_date
        @month_date ||= Date.new(resolved_year, resolved_month, 1)
      end

      def resolved_month
        @resolved_month ||= normalize_month(month) ||
                            normalize_month(request.query_parameters['month']) ||
                            Date.current.month
      end

      def resolved_year
        @resolved_year ||= normalize_year(year) ||
                           normalize_year(request.query_parameters['year']) ||
                           Date.current.year
      end

      def normalize_month(value)
        integer_value = value.to_i
        return if integer_value < 1 || integer_value > 12

        integer_value
      end

      def normalize_year(value)
        integer_value = value.to_i
        return if integer_value <= 0

        integer_value
      end

      def normalized_selected_dates
        @normalized_selected_dates ||= Array(selected_dates).filter_map do |value|
          case value
          when Time, DateTime, ActiveSupport::TimeWithZone
            value.to_date
          when Date
            value
          when String
            Date.parse(value)
          end
        rescue Date::Error
          nil
        end
      end

      def action_params_with_date(date)
        action_params = action.fetch(:params, {})

        if action_params[:project].is_a?(Hash)
          action_params.deep_dup.tap do |params_hash|
            params_hash[:project] = params_hash.fetch(:project).merge(date: date.iso8601)
          end
        elsif action_params['project'].is_a?(Hash)
          action_params.deep_dup.tap do |params_hash|
            params_hash['project'] = params_hash.fetch('project').merge('date' => date.iso8601)
          end
        else
          action_params.merge(date: date.iso8601)
        end
      end
    end
  end
end
