class Rent < ApplicationRecord
  belongs_to :reader, class_name: 'Reader'
  belongs_to :book, class_name: 'Book'
end
