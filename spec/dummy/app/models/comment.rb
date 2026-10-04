# frozen_string_literal: true

# Test model
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  scope :with_text, -> { where.not(text: [nil, '']) }
  scope :without_text, -> { where(text: [nil, '']) }
end
