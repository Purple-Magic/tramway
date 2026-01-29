# frozen_string_literal: true

require 'rails_helper'

feature 'MultiselectComponent', :js, type: :feature do
  before do
    visit new_user_path
  end

  scenario 'allows user to select one option' do
    multiselect 'Admin', from: 'user_role'

    find('body').click

    click_on 'Create user'

    expect(User.last.role).to eq('admin')
  end

  scenario 'allows user to select multiple options' do
    multiselect 'Admin', 'User', from: 'user_role'

    expect(page).to have_selector('.selected-option', text: /Admin/)
    expect(page).to have_selector('.selected-option', text: /User/)

    click_on 'Create user'

    expect(User.last.role).to eq('admin,user')
  end

  scenario 'allows user to select 2 options and unselect the last one' do
    multiselect 'Admin', 'User', from: 'user_role'

    find('.cursor-pointer[data-action="click->multiselect#toggleItem"][data-value="user"]', text: '⨯').click

    expect(page).not_to have_selector('.selected-option', text: 'User')
    expect(page).to have_selector('.selected-option', text: 'Admin')

    click_on 'Create user'

    expect(User.last.role).to eq('admin')
  end

  scenario 'allows user to select 2 options and unselect the first one' do
    multiselect 'Admin', 'User', from: 'user_role'

    find('.cursor-pointer[data-action="click->multiselect#toggleItem"][data-value="admin"]', text: '⨯').click

    expect(page).not_to have_selector('.selected-option', text: 'Admin')
    expect(page).to have_selector('.selected-option', text: 'User')

    click_on 'Create user'

    expect(User.last.role).to eq('user')
  end

  scenario 'runs onchange stimulus action' do
    collect_console_logs(page)

    multiselect 'Admin', from: 'user_role'

    logs = page.evaluate_script('window.collectedLogs')

    expect(logs.any? { |log| log.include?('Form updated') }).to be(true)
  end
end
