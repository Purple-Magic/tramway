# frozen_string_literal: true

class PostDecorator < Tramway::BaseDecorator
  association :user

  def self.list_attributes
    %i[title user]
  end
end
