# frozen_string_literal: true

FactoryBot.define do
  factory :entity, class: 'Tramway::Configs::Entity' do
    name { 'MyString' }
    pages { [:index] }

    initialize_with { new(attributes) }
  end
end
