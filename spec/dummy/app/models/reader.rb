class Reader < ApplicationRecord
  has_many :rents, class_name: 'Rent'
  has_many :feeds, as: :associated
end
