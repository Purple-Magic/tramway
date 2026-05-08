# frozen_string_literal: true

module Tramway
  module Form
    module TramwaySelect
      # Renders input as select
      class SelectAsInputComponent < Tramway::BaseComponent
        option :options
        option :attribute
        option :input
        option :size_class

        def base_classes
          'bg-transparent appearance-none outline-none h-full w-full hidden text-zinc-50 placeholder:text-zinc-500'
        end
      end
    end
  end
end
