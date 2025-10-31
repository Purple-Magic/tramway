# frozen_string_literal: true

class PostDecorator < Tramway::BaseDecorator
  delegate_attributes :title

  association :user

  def self.index_attributes
    %i[title user]
  end
end
