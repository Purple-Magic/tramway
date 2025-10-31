# frozen_string_literal: true

class PostDecorator < Tramway::BaseDecorator
  delegate_attributes :title

  association :user

  def self.index_attributes
    %i[title user]
  end

  def self.show_attributes
    %i[title user_email]
  end

  def user_email
    object.user&.email
  end
end
