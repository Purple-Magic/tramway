# frozen_string_literal: true

module Tramway::Filtering
  def list_filtering(records)
    params[:list_filters]&.each do |filter, _value|
      case decorator_class.list_filters[filter.to_sym][:type]
      when :select
        records = list_filtering_select records, filter
      when :dates
        records = list_filtering_dates records, filter
      end
    end

    records
  end

  def list_filtering_select(records, filter)
    value.present? ? decorator_class.list_filters[filter.to_sym][:query].call(records, value) : records
  end

  def list_filtering_dates(records, filter)
    begin_date = date_filter :begin, filter
    end_date = date_filter :end, filter
    if begin_date.present? && end_date.present? && value.present?
      decorator_class.list_filters[filter.to_sym][:query].call(records, begin_date, end_date)
    else
      records
    end
  end

  def date_filter(type, filter)
    params[:list_filters][filter.to_sym]["#{type}_date".to_sym]
  end

  def filtering(records)
    if params[:filter].present?
      params[:filter] = JSON.parse params[:filter] if params[:filter].is_a? String
      records.ransack(params[:filter]).result(distinct: true)
    else
      records
    end
  end
end
