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
end
