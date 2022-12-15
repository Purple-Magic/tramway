# frozen_string_literal: true

module Tramway
  module RecordRoutesHelper
    def record_path(*args, **options)
      options[:model] ||= params[:model]
      super args, options
    end

    def edit_record_path(*args, **options)
      options[:model] ||= params[:model]
      super args, options
    end

    def new_record_path(*args, **options)
      options[:model] ||= params[:model]
      super args, options
    end

    def records_path(*args, **options)
      options[:model] ||= params[:model]
      super args, options
    end
  end
end
