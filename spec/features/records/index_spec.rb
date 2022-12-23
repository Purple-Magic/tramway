# frozen_string_literal: true

require 'rails_helper'

describe 'Records Index' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end

  before do
    Tramway.set_available_models Book, project: :dummy
  end

  context 'without records' do
    before do
      Book.find_each &:destroy
    end

    it 'shows index page of available model' do
      pass_authorization user

      visit index_page_for model: Book

      expect(page).to have_content 'Books'
    end
  end

  context 'with records' do
    let!(:books) { create_list :book, 5 }

    it 'shows index page of available model' do
      pass_authorization user

      visit index_page_for model: Book

      books.each do |book|
        expect(page).to have_content book.title
      end
    end
  end
end
