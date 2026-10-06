# frozen_string_literal: true

require 'rails_helper'

feature 'TramwayAutocompleteComponent', :js, type: :feature do
  before do
    visit new_user_path
  end

  scenario 'allows user to select an option' do
    tramway_autocomplete 'Team 1', from: 'user_team'

    expect(find("input[name='user[team]']", visible: :all).value).to eq('team1')
  end

  scenario 'does not raise an error when the collection includes an option with a nil label' do
    tramway_autocomplete 'Team 1', from: 'user_team'

    expect(page).to have_no_selector('div.option', text: /^$/, exact: true)
    expect(find("input[name='user[team]']", visible: :all).value).to eq('team1')
  end

  scenario 'allows user to search and select multiple options when combined with multiple: true' do
    tramway_autocomplete 'Engineering', 'Support', from: 'user_departments'

    expect(page).to have_selector('.selected-option', text: /Engineering/)
    expect(page).to have_selector('.selected-option', text: /Support/)

    expect(find("input[name='user[departments]']", visible: :all).value).to eq('engineering,support')
  end
end
