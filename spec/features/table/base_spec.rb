# frozen_string_literal: true

require 'rails_helper'
feature 'Table Base Spec', :js, type: :feature do
  shared_examples 'table classes' do |expected_classes|
    scenario 'check table' do
      expect(page).to have_selector(".#{class_selector(expected_classes.fetch(:table))}.w-full")
    end

    scenario 'check rows' do
      selector = class_selector(expected_classes.fetch(:row))

      expect(page).to have_selector(".#{selector}", count: User.count)
    end

    scenario 'check cells' do
      selector = class_selector(expected_classes.fetch(:cell))

      expect(page).to have_selector(".#{selector}", count: User.count)
    end
  end

  before do
    User.destroy_all

    create_list(:user, rand(1..10))
  end

  context 'with the default classes' do
    before { visit users_path }

    it_behaves_like 'table classes',
                    table: %w[div-table tramway-data-table],
                    row: %w[div-table-row tramway-data-table__row],
                    cell: %w[div-table-cell tramway-data-table__cell]
  end
end
