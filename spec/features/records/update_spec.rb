# frozen_string_literal: true

require 'rails_helper'

describe 'Records update' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end
  let!(:book) { create :book }
  let(:attributes) { attributes_for :book }

  context 'with permissions to update' do
    let(:user_actions) do
      lambda do
        pass_authorization user

        visit index_page_for model: Book

        click_on book.title
        click_on_edit_record

        fill_in 'record[title]', with: attributes[:title], fill_options: { clear: :backspace }
        fill_in 'record[description]', with: attributes[:description]

        click_on_submit
      end
    end

    context 'at all' do
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

        attributes.each do |(_attr, value)|
          expect(page).to have_content value
        end
      end
    end

    context 'at records with title starting with Asya' do
      before do
        Tramway.set_available_models Book => {
          update: lambda do |record|
            record.title[0..3] == 'Asya'
          end
        }, project: :dummy
      end

      let!(:book) { create :book, title: 'Asya' }

      it 'updates record' do
        user_actions.call

        book.reload

        attributes.each do |(attr, value)|
          expect(book.public_send(attr)).to eq value
        end
      end
    end
  end

  context 'without permissions to update at all' do
    before do
      Tramway.set_available_models Book => [ :index ], project: :dummy
    end

    it 'does not update record' do
      pass_authorization user

      visit index_page_for model: Book

      expect(page).not_to have_selector TramwayHelpers::Buttons::EDIT_RECORD_BUTTON_SELECTOR
    end
  end
end
