# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    post
    user
    text { Faker::Lorem.paragraph }
  end
end
