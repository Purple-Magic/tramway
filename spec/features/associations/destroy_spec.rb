# frozen_string_literal: true

require 'rails_helper'

describe 'Associations destroy' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end
  let!(:book) do
    create :book
  end
  let!(:rent) do
    create :rent, book: book
  end

  context 'with permissions to destroy' do
    let(:user_actions) do
      lambda do
        pass_authorization user

        visit index_page_for model: Book
        click_on book.title

        click_on_association_delete_button book.rents.last
      end
    end

    context 'with permissions to destroy all associations' do
      before do
        Tramway.clear_available_models!
        Tramway.set_available_models [Book, Rent], project: :dummy
      end

      it 'deletes record' do
        user_actions.call

        deleted_rents = Rent.only_deleted.pluck :id
        expect(deleted_rents).to include rent.id
      end

      it 'shows page with updated record' do
        user_actions.call

        expect(page).not_to have_content rent.reader.username
      end
    end

    context 'with permissions to destroy associations with titles starting with Asya' do
      before do
        Tramway.set_available_models [Book], project: :dummy
        Tramway.set_available_models({
          Rent => {
            destroy: lambda do |record|
              record.book.title[0..3] == 'Asya'
            end
          }
        }, project: :dummy)
      end

      let!(:book) { create :book, title: "Asya-#{DateTime.now.strftime('%H:%M:%s')}" }
      let!(:rent) { create :rent, book: book }

      it 'deletes record' do
        user_actions.call

        deleted_rents = Rent.only_deleted.pluck :id
        expect(deleted_rents).to include rent.id
      end
    end
  end

  context 'without permissions to destroy at all' do
    before do
      Tramway.set_available_models [ Book ], project: :dummy
      Tramway.set_available_models({ Rent => [:index] }, project: :dummy)
    end

    it 'does not delete record' do
      pass_authorization user

      visit index_page_for model: Book
      click_on book.title

      expect(page).not_to have_selector destroy_record_button_selector(book.rents.last)
    end
  end
end
