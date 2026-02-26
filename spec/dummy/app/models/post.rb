# frozen_string_literal: true

# Test model
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments
  has_many :likes

  scope :search, ->(query) { where('title LIKE ?', "%#{sanitize_sql_like(query)}%") }

  aasm do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: :draft, to: :published
    end
  end
end
