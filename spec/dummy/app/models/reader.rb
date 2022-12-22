class Reader < ApplicationRecord
  has_many :rents, class_name: 'Rent'
end
