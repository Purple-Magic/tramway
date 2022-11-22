# frozen_string_literal: true

FactoryBot.define do
  factory :test_model do
    uid { generate :integer }
    text { generate :string }
  end
end
