# frozen_string_literal: true

require 'rails_helper'

describe 'Records destroy' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end
  let!(:book) { create :book }

  context 'with permissions to destroy' do
    let(:user_actions) do
      lambda do
        pass_authorization user

        visit index_page_for model: Book

        click_on_delete_button(book)
      end
    end

    context 'at all' do
      before do
        Tramway.clear_available_models!
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

    context 'at records with titles starting with Elon' do
      before do
        Tramway.set_available_models Book => {
          destroy: lambda do |record|
            record.title[0..3] == 'Elon'
          end
        }, project: :dummy
      end

      let!(:book) { create :book, title: 'Elon Musk' }

      it 'deletes record' do
        user_actions.call

        deleted_books = Book.only_deleted.pluck :id
        expect(deleted_books).to include book.id
      end
    end
  end

  context 'without permissions to destroy at all' do
    before do
      Tramway.set_available_models Book => [ :index ], project: :dummy
    end

    it 'does not delete record' do
      pass_authorization user

      visit index_page_for model: Book

      expect(page).not_to have_selector destroy_record_button_selector(book)
    end
  end
end
