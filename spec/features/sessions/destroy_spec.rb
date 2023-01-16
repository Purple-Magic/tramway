# frozen_string_literal: true

require 'rails_helper'

describe 'Sign out' do
  before do
    user = create :user
    pass_authorization user
  end

  it 'signed out' do
    click_on_sign_out

    expect(page).to have_content('Password'), page.body
  end
end
