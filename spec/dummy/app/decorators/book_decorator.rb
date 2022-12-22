# frozen_string_literal: true

class BookDecorator < Tramway::ApplicationDecorator
  decorate_association :rents

  delegate_attributes :title
end
