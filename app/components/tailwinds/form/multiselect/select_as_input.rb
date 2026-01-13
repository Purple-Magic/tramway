# frozen_string_literal: true

module Tailwinds
  module Form
    module Multiselect
      # Renders input as select
      class SelectAsInput < Tramway::BaseComponent
        option :options
        option :attribute
        option :input
        option :size_class

        def base_classes
          theme_classes(
            classic: 'bg-transparent appearance-none outline-none h-full w-full hidden text-white placeholder-white',
            neomorphism: 'bg-transparent appearance-none outline-none h-full w-full hidden text-gray-700 ' \
                         'placeholder-gray-400 dark:text-gray-100 dark:placeholder-gray-500'
          )
        end
      end
    end
  end
end
