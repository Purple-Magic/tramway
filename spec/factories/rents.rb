# frozen_string_literal: true

FactoryBot.define do
  factory :rent do
    book
    reader
    begin_date { Time.zone.now }
    end_date { Time.zone.now + 1.day }
  end
end
