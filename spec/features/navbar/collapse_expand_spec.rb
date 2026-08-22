# frozen_string_literal: true

require 'rails_helper'

feature 'Tramway navbar collapse and expand', :js, type: :feature do
  scenario 'starts expanded on desktop' do
    visit '/admin/posts'

    expect(page).to have_css '#desktop-navbar'
    expect(page).to have_css '#tramway-main-container'
    expect(find('#desktop-navbar')['class']).to include('md:w-72')
    expect(find('#tramway-main-container')['class']).to include('md:pl-72')
    expect(page).to have_css '#desktop-navbar-toggle-button[aria-label="Collapse sidebar"]'
  end

  scenario 'collapses to a thinner sidebar on desktop' do
    visit '/admin/posts'

    find('#desktop-navbar-toggle-button').click

    expect(find('#desktop-navbar')['class']).to include('md:w-24')
    expect(find('#desktop-navbar')['data-expanded']).to eq('false')
    expect(find('#tramway-main-container')['class']).to include('md:pl-24')
    expect(page).to have_css '#desktop-navbar-header.opacity-0'
    expect(page).to have_css '#desktop-navbar-toggle-button[aria-label="Expand sidebar"]'
  end

  scenario 'expands back after collapsing' do
    visit '/admin/posts'

    find('#desktop-navbar-toggle-button').click
    find('#desktop-navbar-toggle-button').click

    expect(find('#desktop-navbar')['class']).to include('md:w-72')
    expect(find('#desktop-navbar')['data-expanded']).to eq('true')
    expect(find('#tramway-main-container')['class']).to include('md:pl-72')
    expect(page).to have_css '#desktop-navbar-content:not(.opacity-0)'
    expect(page).to have_css '#desktop-navbar-toggle-button[aria-label="Collapse sidebar"]'
  end
end
