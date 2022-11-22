# frozen_string_literal: true

require 'rails_helper'
require 'kaminari'

RSpec.describe Tramway::Core::ApplicationDecoratedCollection do
  it 'defined decorator class' do
    expect(defined?(described_class)).to be_truthy
  end

  it 'should initialize new decorated array' do
    create_list(:test_model, 20)
    test_models = TestModel.all.page(5)
    decorated_test_models = test_models.map { |t| Tramway::Core::ApplicationDecorator.new t }
    expect { described_class.new decorated_test_models, test_models }.not_to raise_error(StandardError)
  end

  context 'Delegation checks' do
    context 'with TestModel' do
      let(:test_models) { TestModel.all.page(5) }
      let(:decorated_test_models) { test_models.map { |t| Tramway::Core::ApplicationDecorator.new t } }
      let(:decorated_collection) { described_class.new decorated_test_models, test_models }

      it 'delegates total_pages' do
        expect(decorated_collection.total_pages).to eq test_models.total_pages
      end

      it 'delegates current_page' do
        expect(decorated_collection.current_page).to eq test_models.current_page
      end

      it 'delegates limit_value' do
        expect(decorated_collection.limit_value).to eq test_models.limit_value
      end
    end
  end

  context 'Object methods checks' do
    let(:test_models) { TestModel.all.page(5) }
    let(:decorated_collection) do
      decorated_test_models = test_models.map { |t| Tramway::Core::ApplicationDecorator.new t }
      described_class.new decorated_test_models, test_models
    end

    it 'returns original_array' do
      expect(decorated_collection.original_array).to eq test_models
    end
  end
end
