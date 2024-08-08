# frozen_string_literal: true

class UserDecorator < Tramway::BaseDecorator
  association :posts

  def published_posts
    tramway_decorate object.posts.published
  end
end
