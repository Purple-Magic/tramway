# frozen_string_literal: true

require 'rails_helper'

feature 'TramwaySelectComponent', :js, type: :feature do
  before do
    visit new_user_path
  end

  scenario 'allows user to select one option' do
    tramway_select 'Admin', from: 'user_role'

    expect(find("input[name='user[role]']", visible: :all).value).to eq('admin')
  end

  scenario 'allows user to select multiple options' do
    tramway_select 'Admin', 'User', from: 'user_role'

    expect(page).to have_selector('.selected-option', text: /Admin/)
    expect(page).to have_selector('.selected-option', text: /User/)

    expect(find("input[name='user[role]']", visible: :all).value).to eq('admin,user')
  end

  scenario 'allows user to select 2 options and unselect the last one' do
    tramway_select 'Admin', 'User', from: 'user_role'

    find('.cursor-pointer[data-action="click->tramway-select#toggleItem"][data-value="user"]', text: '⨯').click

    expect(page).not_to have_selector('.selected-option', text: 'User')
    expect(page).to have_selector('.selected-option', text: 'Admin')

    expect(find("input[name='user[role]']", visible: :all).value).to eq('admin')
  end

  scenario 'allows user to select 2 options and unselect the first one' do
    tramway_select 'Admin', 'User', from: 'user_role'

    find('.cursor-pointer[data-action="click->tramway-select#toggleItem"][data-value="admin"]', text: '⨯').click

    expect(page).not_to have_selector('.selected-option', text: 'Admin')
    expect(page).to have_selector('.selected-option', text: 'User')

    expect(find("input[name='user[role]']", visible: :all).value).to eq('user')
  end

  scenario 'runs onchange stimulus action' do
    collect_console_logs(page)

    tramway_select 'Admin', from: 'user_role'

    logs = page.evaluate_script('window.collectedLogs')

    expect(logs.any? { |log| log.include?('Form updated') }).to be(true)
  end
end
