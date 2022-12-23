# frozen_string_literal: true

require 'rails_helper'

describe 'Records update' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end
  let!(:book) { create :book }
  let(:attributes) { attributes_for :book }
  let(:user_actions) do
    lambda do
      pass_authorization user

      visit index_page_for model: Book

      click_on book.title
      find('.btn.btn-warning', match: :first).click

      fill_in 'record[title]', with: attributes[:title], fill_options: { clear: :backspace }
      fill_in 'record[description]', with: attributes[:description]

      click_on_submit
    end
  end

  before do
    Tramway.set_available_models Book, project: :dummy
  end

  it 'updates new record with needed attributes' do
    user_actions.call

    book.reload

    attributes.each do |(attr, value)|
      expect(book.public_send(attr)).to eq value
    end
  end

  it 'shows page with updated record' do
    user_actions.call

    attributes.each do |(attr, value)|
      expect(page).to have_content value
    end
  end
end
