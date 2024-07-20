# frozen_string_literal: true

# Test model
class Post < ApplicationRecord
  belongs_to :user

  aasm do
    state :draft, initial: true
    state :published

    event :publish do
      transitions from: :draft, to: :published
    end
  end
end
