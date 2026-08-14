# frozen_string_literal: true

require 'rails_helper'

feature 'Navbar layout', type: :feature do
  scenario 'injects a desktop offset for the vertical navbar' do
    visit '/navbar-test'

    expect(page).to have_css('style', visible: :all, text: 'body {')
    expect(page).to have_css('style', visible: :all, text: 'padding-left: 16rem;')
    expect(page).to have_css('style', visible: :all, text: "body[data-tramway-navbar-collapsed='true']")
  end

  scenario 'stretches vertical navbar items full width', :js do
    page.driver.browser.manage.window.resize_to(1440, 1200)
    visit '/navbar-test'

    item = all('#desktop-navbar [data-tramway-navbar-content] li', visible: :all).first
    link = all('#desktop-navbar [data-tramway-navbar-content] li > a', visible: :all).first

    expect(item.rect.width).to be > 200
    expect(link.rect.width).to be_within(2).of(item.rect.width)
  end

  scenario 'collapses the desktop vertical navbar', :js do
    page.driver.browser.manage.window.resize_to(1440, 1200)
    visit '/navbar-test'

    expect(page).to have_css('#desktop-navbar-collapse-button', visible: :all)
    expect(page).to have_css('#desktop-navbar [data-tramway-navbar-content]', visible: :visible)

    button = find('#desktop-navbar-collapse-button', visible: :all)
    navbar = find('#desktop-navbar', visible: :all)
    before_button_center_x = (button.rect.x - navbar.rect.x) + (button.rect.width / 2.0)
    before_nav_width = navbar.rect.width

    expect(before_button_center_x).to be > (before_nav_width * 0.6)
    expect(navbar.rect.height - (button.rect.y + button.rect.height - navbar.rect.y)).to be_within(8).of(0)

    button.click

    expect(page).to have_css('body[data-tramway-navbar-collapsed="true"]', visible: :all)
    expect(page).to have_css('#desktop-navbar[data-tramway-navbar-collapsed="true"]', visible: :all)
    expect(page).to have_css('#desktop-navbar[data-tramway-navbar-collapsed="true"] [data-tramway-navbar-content]', visible: :hidden)

    button = find('#desktop-navbar-collapse-button', visible: :all)
    collapsed_navbar = find('#desktop-navbar', visible: :all)
    after_button_center_x = (button.rect.x - collapsed_navbar.rect.x) + (button.rect.width / 2.0)
    collapsed_nav_width = collapsed_navbar.rect.width

    expect(after_button_center_x).to be_within(collapsed_nav_width * 0.15).of(collapsed_nav_width / 2.0)
    expect(collapsed_navbar.rect.height - (button.rect.y + button.rect.height - collapsed_navbar.rect.y)).to be_within(8).of(0)
  end
end
