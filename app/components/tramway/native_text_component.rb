# frozen_string_literal: true

module Tramway
  class NativeTextComponent < Tramway::BaseComponent
    option :text
    option :size, optional: true, default: -> { :middle }
    option :klass, optional: true, default: -> { '' }

    def lines
      @lines ||= text&.split("\n")
    end

    def text_class
      case size
      when :small
        'text-sm'
      when :large
        'text-lg'
      when :middle
        'text-base'
      else
        'md:text-sm lg:text-base'
      end + " #{klass}"
    end
  end
end
