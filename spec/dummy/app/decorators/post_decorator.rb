# frozen_string_literal: true

class PostDecorator < Tramway::BaseDecorator
  association :user

  def self.list_attributes
    [:title, :user]
  end
end
