# frozen_string_literal: true

require 'rails_helper'

describe 'Sign in' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end

  before do
    Tramway::User.find_each { |u| u.password = '123', u.save! }
  end

  it 'sign_ins' do
    pass_authorization user

    expect(page).to have_content "#{user.first_name} #{user.last_name}"
  end
end
