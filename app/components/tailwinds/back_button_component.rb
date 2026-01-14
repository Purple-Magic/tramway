# frozen_string_literal: true

module Tailwinds
  # Backbutton component
  class BackButtonComponent < BaseComponent
    def back_button_classes
      theme_classes(
        classic: 'btn btn-delete bg-orange-400 hover:bg-orange-200 text-white font-semibold py-2 px-4 ' \
                 'rounded-xl ml-2 shadow-md'
      )
    end
  end
end
