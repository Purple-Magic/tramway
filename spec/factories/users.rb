# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    trait :with_posts do
      after :create do |u|
        create :post, user: u
      end
    end
  end
end
