# frozen_string_literal: true

FactoryBot.define do
  factory :feed do
    associated_type { %w[Book Reader].sample }
    associated_id { associated_type.constantize.last }
  end
end
