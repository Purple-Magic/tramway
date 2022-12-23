# frozen_string_literal: true

require 'rails_helper'

describe 'Records Create' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end
  let(:attributes) { attributes_for :book }
  let(:user_actions) do
    lambda do
      pass_authorization user

      visit index_page_for model: Book

      click_on_new_record

      fill_in 'record[title]', with: attributes[:title]
      fill_in 'record[description]', with: attributes[:description]

      click_on_submit
    end
  end

  context 'with permission to create' do
    before do
      Tramway.set_available_models Book, project: :dummy
    end

    it 'creates new record' do
      count = Book.count

      user_actions.call

      expect(count).to eq(Book.count - 1)
    end

    it 'creates new record with needed attributes' do
      user_actions.call

      book = Book.last

      attributes.each do |(attr, value)|
        expect(book.public_send(attr)).to eq value
      end
    end

    it 'shows page with new record' do
      user_actions.call

      attributes.each do |(_attr, value)|
        expect(page).to have_content value
      end
    end
  end

  context 'without permission to create' do
    before do
      Tramway.set_available_models Book => [ :index ], project: :dummy
    end

    it 'does not create new record' do
      pass_authorization user

      visit index_page_for model: Book

      expect(page).not_to have_selector TramwayHelpers::Buttons::NEW_RECORD_BUTTON_SELECTOR
    end
  end
end
