# frozen_string_literal: true

module Tramway
  module Form
    module TramwaySelect
      # Renders input as select
      class SelectAsInputComponent < Tramway::BaseComponent
        option :options
        option :attribute
        option :input

        def base_classes
          'tramway-select__input hidden'
        end
      end
    end
  end
end
