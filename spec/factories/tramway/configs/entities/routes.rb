# frozen_string_literal: true

FactoryBot.define do
  factory 'entities/route', class: 'Tramway::Configs::Entities::Route' do
    initialize_with { new(attributes) }
  end
end
