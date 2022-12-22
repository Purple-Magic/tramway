require 'rails_helper'

describe 'Sign in' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end

  before do
    Tramway::User.find_each { |u| u.password = '123', u.save! }
  end

  it 'should create event' do
    visit '/admin'
    fill_in 'Email', with: user[:email]
    fill_in 'Password', with: "123"
    click_on 'Sign In', class: 'btn-success'

    expect(page).to have_content "#{user.first_name} #{user.last_name}"
  end
end
