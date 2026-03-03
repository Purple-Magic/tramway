# frozen_string_literal: true

require 'rails_helper'

feature 'TramwayAutocompleteComponent', :js, type: :feature do
  before do
    visit new_user_path
  end

  scenario 'allows user to select an option' do
    tramway_autocomplete 'Team 1', from: 'user_team'

    expect(page).to have_selector('div.option', text: 'Team 1')
    expect(page).not_to have_selector('div.option', text: 'Team 2')
  end
end
