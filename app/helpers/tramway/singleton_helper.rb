# frozen_string_literal: true

module Tramway
  module SingletonHelper
    # FIXME: replace to module
    def current_model_singleton_path(*args, **options)
      singleton_path args, options.merge(model: params[:model])
    end

    def edit_current_model_singleton_path(*args, **options)
      edit_singleton_path args, options.merge(model: params[:model])
    end
  end
end
