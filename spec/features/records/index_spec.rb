# frozen_string_literal: true

require 'rails_helper'

describe 'Records Index' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end

  before do
    Tramway.set_available_models Book, project: :dummy
  end

  context 'without books' do
    before do
      Book.delete_all
    end

    it 'shows index page of available model' do
      visit '/admin'
      fill_in 'Email', with: user[:email]
      fill_in 'Password', with: '123'
      click_on 'Sign In', class: 'btn-success'

      visit index_page_for model: Book

      expect(page).to have_content 'Books'
    end
  end

  context 'with books' do
    let!(:books) { create_list :book, 5 }

    it 'shows index page of available model' do
      visit '/admin'
      fill_in 'Email', with: user[:email]
      fill_in 'Password', with: '123'
      click_on 'Sign In', class: 'btn-success'

      visit index_page_for model: Book

      books.each do |book|
        expect(page).to have_content book.title
      end
    end
  end
end
