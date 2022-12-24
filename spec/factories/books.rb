# frozen_string_literal: true

FactoryBot.define do
  factory :book do
    title { "#{Faker::Book.title}-#{SecureRandom.hex(2)}" }
    description

    after :create do |book|
      create_list :feed, 5, associated: book
    end
  end
end
