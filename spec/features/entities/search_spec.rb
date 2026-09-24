# frozen_string_literal: true

require 'rails_helper'
require 'tramway/warnings'

feature 'Entities Search', :js, type: :feature do
  let(:row_selector) { ".div-table-row[role='row']:not([aria-label='Table Header'])" }

  before do
    Post.destroy_all
    create(:post, title: 'Alpha post', aasm_state: :published)
    create(:post, title: 'Beta post', aasm_state: :published)
  end

  scenario 'shows search form on index page' do
    visit '/admin/posts'

    expect(page).to have_field('query')
    expect(page).to have_button('Search')
  end

  scenario 'filters results by query' do
    visit '/admin/posts'

    fill_in 'query', with: 'Alpha'
    click_button 'Search'

    expect(page).to have_selector(row_selector, count: 1)
    expect(page).to have_content('Alpha post')
    expect(page).not_to have_content('Beta post')
  end
end
