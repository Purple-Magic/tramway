# frozen_string_literal: true

module Tailwinds
  # Backbutton component
  class BackButtonComponent < BaseComponent
    def back_button_classes
      theme_classes(
        classic: 'btn btn-delete bg-orange-500 hover:bg-orange-700 text-white font-bold py-2 px-4 rounded ml-2',
        neomorphism: 'btn btn-delete bg-orange-100 hover:bg-orange-200 text-orange-800 font-semibold py-2 px-4 ' \
                     'rounded-xl ml-2 shadow-md dark:bg-orange-800 dark:text-orange-100 dark:hover:bg-orange-700'
      )
    end
  end
end
