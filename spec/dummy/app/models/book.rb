class Book < ApplicationRecord
  has_many :rents, class_name: 'Rent'
  has_many :feeds, as: :associated, class_name: 'Feed'

  aasm column: :state do
    state :active
    state :inactive
  end
end
