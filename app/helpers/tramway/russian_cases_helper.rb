# frozen_string_literal: true

module Tramway::RussianCasesHelper
  def case_word(model_name, case_name)
    word_case = I18n.t("cases.#{model_name.name.underscore}.#{case_name}")
    return word_case if word_case.present?

    raise "There is not #{case_name} implementation for \"#{model_name}\""
  end

  def genitive(word)
    case_word word, :genitive
  end

  def instrumental(word)
    case_word word, :instrumental
  end

  def dative(word)
    case_word word, :dative
  end

  def russian_plural(word)
    case_word word, :plural
  end
end
