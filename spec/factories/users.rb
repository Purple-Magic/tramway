FactoryBot.define do
  factory :user, class: 'Tramway::User' do
    email
    password
    first_name { generate :string }
    last_name { generate :string }
  end
end
