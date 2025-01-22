# frozen_string_literal: true

class PostDecorator < Tramway::BaseDecorator
  delegate_attributes :title

  association :user

  def self.list_attributes
    %i[title user]
  end
end
