# frozen_string_literal: true

require 'active_support/inflector/methods'

class String
  def pluralize(count = nil, locale = :en)
    if locale == :ru
      case count
      when :many
        I18n.t('cases.')
      end
    else
      locale = count if count.is_a? Symbol
      count == 1 ? dup : ActiveSupport::Inflector.pluralize(self, locale)
    end
  end
end
