# frozen_string_literal: true

class Admin::CommentDecorator < Tramway::BaseDecorator
  delegate_attributes :text

  association :user

  class << self
    def index_attributes
      %i[text user_email]
    end
  end

  def user_email
    object.user&.email
  end
end
