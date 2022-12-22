# frozen_string_literal: true

FactoryBot.define do
  factory :rent do
    book
    reader
    begin_date { DateTime.now }
    begin_date { DateTime.now + 1.day }
  end
end
