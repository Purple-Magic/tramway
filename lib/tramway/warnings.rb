# frozen_string_literal: true

module Tramway
  # Warnings module provides methods to log warnings for different scenarios
  module Warnings
    module_function

    def search_fallback(model_class)
      Rails.logger.warn(
        "Tramway search: `#{model_class}.search` is not defined. " \
        "Falling back to `#{model_class}.tramway_search`. " \
        'This is a generic fallback and not tailored to your data structure, ' \
        'so it is not intended for long-term use and may be slow or not scalable.'
      )
    end
  end
end
