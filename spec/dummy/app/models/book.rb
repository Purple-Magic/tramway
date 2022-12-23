class Book < ApplicationRecord
  has_many :rents
  has_many :feeds, as: :associated

  aasm :state do
    state :active
    state :inactive
  end
end
