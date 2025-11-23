# frozen_string_literal: true

class PostDecorator < Tramway::BaseDecorator
  delegate_attributes :title, :aasm_state

  association :user

  def self.index_attributes
    %i[title user]
  end

  def show_attributes
    %i[title aasm_state user_email]
  end

  def user_email
    object.user&.email
  end

  def show_header_content
    lambda do |decorated_object|
      "Show header for #{decorated_object.title}"
    end
  end
end
