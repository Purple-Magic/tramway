# frozen_string_literal: true

module Tramway
  module CasesHelper
    def plural(word)
      if I18n.locale == :ru
        russian_plural word
      else
        if word.respond_to?(:model_name)
          word.model_name.human.pluralize(I18n.locale)
        else
          word.human.pluralize(I18n.locale)
        end
      end
    end
  end
end
