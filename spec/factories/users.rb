FactoryBot.define do
  factory :user, class: 'Tramway::User' do
    email
    first_name { generate :string }
    last_name { generate :string }

    after :create do |user|
      user.password = '123'
      user.save!
    end
  end
end
