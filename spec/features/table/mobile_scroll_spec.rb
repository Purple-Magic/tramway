# frozen_string_literal: true

require 'rails_helper'

feature 'Table Mobile Scroll Spec', :js, type: :feature do
  let(:row_selector) { ".div-table-row[role='row']:not([aria-label='Table Header'])" }

  around do |example|
    with_theme(:classic) { example.run }
  end

  before do
    Capybara.javascript_driver = :headless_chrome_mobile

    User.destroy_all
    create_list(:user, 3)

    visit users_path
  end

  after do
    Capybara.javascript_driver = :headless_chrome
  end

  scenario 'renders the full table on mobile with a horizontal scroll container' do
    table = find('.div-table')

    expect(table[:class].to_s.split).to include('overflow-x-auto')
    expect(page).to have_selector(row_selector, minimum: 1)
  end

  scenario 'keeps every column visible instead of hiding all but the first' do
    header_cells = all(".div-table-row[aria-label='Table Header'] .div-table-cell", minimum: 1)

    header_cells.each do |cell|
      expect(cell[:class].to_s.split).not_to include('hidden')
    end
  end
end
