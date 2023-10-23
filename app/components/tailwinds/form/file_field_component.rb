# frozen_string_literal: true

class Tailwinds::Form::FileFieldComponent < ViewComponent::Base
  def initialize(input, attribute, object_name: nil, **options)
    @label = options[:label] || attribute.to_s.capitalize
    @for = "#{object_name}_#{attribute}"
    @input = input
  end
end
