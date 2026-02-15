# frozen_string_literal: true

require 'rails_helper'

feature 'Chat component', :js, type: :feature do
  scenario 'renders sent and received messages on chat page' do
    visit '/chat'

    expect(page).to have_css('#chat')
    expect(page).to have_css('#messages')

    expect(page).to have_css('.items-end', text: 'Sent from feature spec')
    expect(page).to have_css('.items-start', text: 'Received in feature spec')
  end
end
