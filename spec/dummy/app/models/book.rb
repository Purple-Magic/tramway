class Book < ApplicationRecord
  has_many :rents
  has_many :feeds, as: :associated
end