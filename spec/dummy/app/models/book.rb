class Book < ApplicationRecord
  has_many :rents, class_name: 'Rent'
end
