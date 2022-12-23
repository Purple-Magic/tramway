# frozen_string_literal: true

require 'rails_helper'

describe 'Associations Create' do
  let!(:user) do
    Tramway::User.create! password: '123', **attributes_for(:user)
  end
  let!(:book) { create :book }
  let(:attributes) { attributes_for :rent }
  let(:user_actions) do
    lambda do
      pass_authorization user

      visit index_page_for model: Book

      click_on book.title
      click_on 'Add rent'

      fill_in 'record[begin_date]', with: attributes[:begin_date]
      fill_in 'record[end_date]', with: attributes[:end_date]

      click_on_submit
    end
  end

  context 'with permission to create' do
    before do
      Tramway.set_available_models Book, Rent, project: :dummy
    end

    it 'creates new record' do
      count = Rent.count

      user_actions.call

      expect(count).to eq(Rent.count - 1)
    end

    it 'creates new record with needed attributes' do
      user_actions.call

      rent = Rent.last

      attributes.each do |(attr, value)|
        if attr.in? %i[begin_date end_date]
          expect(rent.public_send(attr).strftime('%d.%m.%Y %H:%M:%S')).to eq value.strftime('%d.%m.%Y %H:%M:%S')
        else
          expect(rent.public_send(attr)).to eq value
        end
      end
    end

    it 'shows page with new record' do
      user_actions.call

      rent = Rent.last
      expect(page).to have_content rent.reader.username
    end
  end

  context 'without permission to create' do
    before do
      Tramway.set_available_models Book, { Rent => [:index] }, project: :dummy
    end

    it 'does not create new record' do
      pass_authorization user

      visit index_page_for model: Book
      click_on book.title

      expect(page).not_to have_content 'Add rent'
    end
  end
end
