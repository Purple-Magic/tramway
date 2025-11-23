# frozen_string_literal: true

class CommentDecorator < Tramway::BaseDecorator
  delegate_attributes :text

  association :user

  def self.index_attributes
    %i[text user_email]
  end

  def user_email
    object.user&.email
  end
end
