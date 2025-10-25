# frozen_string_literal: true

require 'rails_helper'
require 'pagination/shared'

feature 'Order Index Page on Mobile', type: %i[feature admin] do
  before do
    Capybara.javascript_driver = :headless_chrome_mobile

    User.destroy_all

    create_list :user, 125

    visit users_path
  end

  after do
    Capybara.javascript_driver = :headless_chrome
  end

  it 'displays 1..3 pages links and next/last buttons for a smaller viewport' do
    expect(page).to have_css('span', text: '1', class: 'bg-purple-500')

    (2..3).each do |i|
      expect(page).to have_link(i.to_s, href: users_path(page: i))
    end
  end

  it 'displays next/last buttons with adjusted pagination' do
    expect(page).to have_link('🠖', href: users_path(page: 2))
    expect(page).to have_link('⭲', href: users_path(page: 5))
  end

  it_behaves_like 'Click on Page', '2'
  it_behaves_like 'Click on Page', '3'
  it_behaves_like 'Click on Page', '2', '🠖'
  it_behaves_like 'Click on Page', '5', '⭲'
end
