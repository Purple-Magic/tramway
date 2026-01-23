# frozen_string_literal: true

module Admin
  class PostForm < Tramway::BaseForm
    properties :title, :text, :user_id

    fields title: :text,
           text: :text_area,
           user_id: {
             type: :hidden,
             value: -> { User.first.id }
           },
           post_type: {
             type: :select,
             collection: %w[public private]
           }
  end
end
