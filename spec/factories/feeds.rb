FactoryBot.define do
  factory :feed do
    associated_type { [ 'Book', 'Reader' ].sample }
    associated_id { associated_type.constantize.last }
  end
end
