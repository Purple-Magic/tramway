require 'rails_helper'

describe 'Sign in' do
  let!(:user) { create :user }

  it 'should create event' do
    visit '/admin'
    fill_in 'Email', with: user[:email]
    fill_in 'Пароль', with: user[:password]
    click_on 'Войти', class: 'btn-success'

    expect(page).to have_content "#{user.first_name} #{user.last_name}"
  end
end
