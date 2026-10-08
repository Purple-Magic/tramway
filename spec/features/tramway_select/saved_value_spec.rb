# frozen_string_literal: true

require 'rails_helper'

feature 'TramwaySelectComponent saved value', :js, type: :feature do
  scenario 'redisplays a previously saved multiple selection on an autocomplete + multiple select' do
    visit new_user_path(saved_departments: 1)

    expect(page).to have_selector('.selected-option', text: /Engineering/)
    expect(page).to have_selector('.selected-option', text: /Support/)
    expect(find("input[name='user[departments]']", visible: :all).value).to eq('engineering,support')
  end

  scenario 'redisplays a previously saved single selection on an autocomplete select' do
    visit new_user_path(saved_team: 1)

    expect(page).to have_selector('.selected-option', text: /Team 1/)
    expect(find("input[name='user[team]']", visible: :all).value).to eq('team1')
  end
end
