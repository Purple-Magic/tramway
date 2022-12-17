# frozen_string_literal: true

class TestModelDecorator < Tramway::ApplicationDecorator
  decorate_association :association_models, as: :record
  decorate_association :another_association_models

  delegate_attributes :title
end
