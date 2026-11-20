# frozen_string_literal: true

module Tramway
  # Title component
  class TitleComponent < Tramway::BaseComponent
    option :text
    option :options, optional: true, default: -> { {} }

    def title_classes
      ['tramway-title', options[:class]].compact.join(' ')
    end
  end
end
