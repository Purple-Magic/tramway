# frozen_string_literal: true

require 'rails_helper'

describe 'Records Create' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end

  before do
    Tramway.set_available_models Book, project: :dummy
  end

  it 'creates new record' do
      visit '/admin'
      fill_in 'Email', with: user[:email]
      fill_in 'Password', with: '123'
      click_on 'Sign In', class: 'btn-success'

      visit '/admin/records?model=Book'
  end
end
