# frozen_string_literal: true

module Admin
  class PostDecorator < Tramway::BaseDecorator
    delegate_attributes :title, :aasm_state, :text

    association :user
    association :comments, decorator: Admin::CommentDecorator

    def self.index_attributes
      %i[title user]
    end

    def show_attributes
      %i[title text aasm_state user_email]
    end

    def show_associations
      %i[comments]
    end

    def user_email
      object.user&.email
    end

    def show_header_content
      "Show header for #{title}"
    end
  end
end
