# frozen_string_literal: true

require 'rails_helper'
feature 'Table Base Spec', :js, type: :feature do
  shared_examples 'table theme classes' do |theme_classes|
    scenario 'check table' do
      expect(page).to have_selector(".#{class_selector(theme_classes.fetch(:table))}.w-full")
    end

    scenario 'check rows' do
      selector = class_selector(theme_classes.fetch(:row))

      expect(page).to have_selector(".#{selector}", count: User.count)
    end

    scenario 'check cells' do
      selector = class_selector(theme_classes.fetch(:cell))

      expect(page).to have_selector(".#{selector}", count: User.count)
    end
  end

  before do
    User.destroy_all

    create_list(:user, rand(1..10))
  end

  context 'with classic theme' do
    around { |example| with_theme(:classic) { example.run } }

    before { visit users_path }

    it_behaves_like 'table theme classes',
                    table: %w[div-table text-left rtl:text-right text-gray-400],
                    row: %w[
                      div-table-row grid gap-4 border-b last:border-b-0 bg-gray-800 border-gray-700 grid-cols-1
                    ],
                    cell: %w[div-table-cell px-6 py-4 font-medium text-white text-base]
  end

  context 'with neomorphism theme' do
    around { |example| with_theme(:neomorphism) { example.run } }

    before { visit users_path }

    it_behaves_like 'table theme classes',
                    table: %w[div-table text-left rtl:text-right text-gray-500 dark:text-gray-300],
                    row: %w[
                      div-table-row grid gap-4 border-b last:border-b-0 bg-gray-100 border-gray-200 grid-cols-1
                      dark:bg-gray-900 dark:border-gray-700
                    ],
                    cell: %w[div-table-cell px-6 py-4 font-medium text-gray-700 text-base dark:text-gray-100]
  end
end
