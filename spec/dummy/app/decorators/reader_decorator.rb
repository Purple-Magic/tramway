# frozen_string_literal: true

class ReaderDecorator < Tramway::ApplicationDecorator
  decorate_association :rents

  delegate_attributes :username

  alias title username
end
