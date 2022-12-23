# frozen_string_literal: true

require 'rails_helper'

describe 'Records destroy' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end
  let!(:book) { create :book }
  let(:user_actions) do
    lambda do
      pass_authorization user

      visit index_page_for model: Book

      click_on_delete_button(book)
    end
  end

  before do
    Tramway.set_available_models Book, project: :dummy
  end

  it 'deletes record' do
    user_actions.call

    deleted_books = Book.only_deleted.pluck :id
    expect(deleted_books).to include book.id
  end

  it 'shows page with updated record' do
    user_actions.call

    expect(page).not_to have_content book.title
  end
end
