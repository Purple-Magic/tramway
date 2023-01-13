# frozen_string_literal: true

require 'rails_helper'

describe 'Sign in' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end

  before do
    Tramway::User.find_each { |u| u.password = '123', u.save! }
  end

  context 'with success' do
    it 'redirect to signed_in page' do
      pass_authorization user

      expect(page).to have_content "#{user.first_name} #{user.last_name}"
    end

    it 'redirect to root_path' do
      pass_authorization user

      expect("#{current_path}/").to eq Tramway::Engine.routes.url_helpers.root_path
    end
  end

  context 'with failure' do
    it 'does not sign in' do
      visit home_page

      fill_in 'Email', with: 'not_existed_user@email.com'
      fill_in 'Password', with: '123'

      click_on 'Sign In', class: 'btn-success'

      expect(page).to have_content 'Wrong email or password'
    end
  end
end
