# frozen_string_literal: true

class BookDecorator < Tramway::ApplicationDecorator
  decorate_association :rents
  decorate_association :feeds, as: :associated

  delegate_attributes :title
end
