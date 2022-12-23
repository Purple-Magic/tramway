class Rent < ApplicationRecord
  belongs_to :reader, class_name: 'Reader'
  belongs_to :book, class_name: 'Book'

  aasm column: :state do
    state :in_progress
    state :done
  end
end
