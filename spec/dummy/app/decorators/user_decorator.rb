# frozen_string_literal: true

# Test decorator User model as a default
class UserDecorator < Tramway::BaseDecorator
  association :posts
end
