# frozen_string_literal: true

class UserDecorator < Tramway::BaseDecorator
  association :posts
end
