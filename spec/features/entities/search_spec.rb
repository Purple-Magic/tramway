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

  scenario 'falls back to tramway_search when model does not define search' do
    Article.destroy_all
    create(:article, title: 'Alpha article')
    create(:article, title: 'Beta article')

    allow(Tramway::Warnings).to receive(:search_fallback)
    allow(Article).to receive(:columns).and_return([])

    visit '/admin/articles'

    fill_in 'query', with: 'Alpha'
    click_button 'Search'

    expect(Tramway::Warnings).to have_received(:search_fallback).with(Article)

    expect(page).to have_selector(row_selector, count: 2)
    expect(page).to have_content('Alpha article')
    expect(page).to have_content('Beta article')
  end
end
