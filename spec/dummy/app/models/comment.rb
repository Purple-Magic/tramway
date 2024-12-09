# frozen_string_literal: true

# Test model
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
end
