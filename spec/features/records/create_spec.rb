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
    visit home_page
    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: '123'
    click_on 'Sign In', class: 'btn-success'

    visit index_page_for model: Book

    
  end
end
