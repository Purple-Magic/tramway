class Feed < ApplicationRecord
  belongs_to :associated, polymorphic: true
end
