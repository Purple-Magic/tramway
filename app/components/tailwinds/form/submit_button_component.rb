# frozen_string_literal: true

class Tailwinds::Form::SubmitButtonComponent < ViewComponent::Base
  def initialize(action, **options)
    @options = options.except :type

    @text = action.is_a?(String) ? action : action.to_s.capitalize
  end
end
