# frozen_string_literal: true

require 'rails_helper'
require 'kaminari'

RSpec.describe Tramway::ApplicationDecoratedCollection do
  it 'defined decorator class' do
    expect(defined?(described_class)).to be_truthy
  end

  it 'initializes new decorated array' do
    create_list(:book, 20)
    books = Book.all.page(5)
    decorated_books = books.map { |t| Tramway::ApplicationDecorator.new t }
    expect { described_class.new decorated_books, books }.not_to raise_error(StandardError)
  end

  context 'with delegation' do
    context 'with Book' do
      let(:books) { Book.all.page(5) }
      let(:decorated_books) { books.map { |t| Tramway::ApplicationDecorator.new t } }
      let(:decorated_collection) { described_class.new decorated_books, books }

      it 'delegates total_pages' do
        expect(decorated_collection.total_pages).to eq books.total_pages
      end

      it 'delegates current_page' do
        expect(decorated_collection.current_page).to eq books.current_page
      end

      it 'delegates limit_value' do
        expect(decorated_collection.limit_value).to eq books.limit_value
      end
    end
  end

  context 'with object methods' do
    let(:books) { Book.all.page(5) }
    let(:decorated_collection) do
      decorated_books = books.map { |t| Tramway::ApplicationDecorator.new t }
      described_class.new decorated_books, books
    end

    it 'returns original_array' do
      expect(decorated_collection.original_array).to eq books
    end
  end
end
