# frozen_string_literal: true

require 'rails_helper'

describe 'Navbar' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end
  let!(:book) { create :book }

  before do
    Tramway.set_available_models Book, project: :dummy
    Tramway.navbar_structure Book, project: :dummy
  end

  it 'shows index page via navbar' do
    pass_authorization user

    click_on 'Books'

    expect(page).to have_content book.title
  end
end
