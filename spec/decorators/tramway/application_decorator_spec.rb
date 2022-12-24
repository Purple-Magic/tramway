# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tramway::ApplicationDecorator do
  let(:errors) { YAML.load_file('spec/yaml/errors.yml') }
  let(:methods) { YAML.load_file('spec/yaml/methods.yml')['methods'] }

  it 'defined decorator class' do
    expect(defined?(described_class)).to be_truthy
  end

  it 'initializes new decorated object' do
    obj = 'it can be any object'
    expect { described_class.new obj }.not_to raise_error(StandardError)
  end

  context 'with class' do
    let(:class_methods) do
      described_class.methods -
        described_class.superclass.methods -
        bad_ass_monkey_patching_methods(source: :active_support) -
        bad_ass_monkey_patching_methods(source: %i[action_view helpers])
    end

    it 'class should have only this methods list' do
      expect(class_methods.should =~ methods['class_methods'].map(&:to_sym)).to be_truthy
    end

    it 'returns list attributes' do
      expect(described_class.list_attributes).to eq []
    end

    it 'returns show attributes' do
      expect(described_class.show_attributes).to eq []
    end

    it 'returns show associations' do
      expect(described_class.show_associations).to eq []
    end

    it 'returns model class' do
      expect(described_class.model_class).to eq Tramway::Application
    end

    it 'returns model name' do
      expect(described_class.model_name).to be_nil
    end

    it 'returns collection only with all by default' do
      expect(described_class.collections).to eq [:all]
    end

    it 'decorates simple object' do
      obj = 'it can be any object'
      expect(described_class.decorate(obj)).to be_a described_class
    end

    context 'with Book' do
      it 'has 10 items' do
        create_list :book, 10
        models = Book.limit(10)
        expect(described_class.decorate(models).count).to eq 10
      end

      it 'decorates all items' do
        create_list :book, 10
        models = Book.limit(10)
        expect(described_class.decorate(models)).to all be_a(described_class)
      end

      it 'decorates association models' do
        book = create :book
        create_list :rent, 10, book_id: book.id
        decorated_book = BookDecorator.decorate book
        expect(decorated_book.rents).to all be_a(RentDecorator)
      end

      it 'creates `association_as` method after decorating association' do
        book = create :book
        create_list :feed, 10, associated_id: book.id, associated_type: 'Book'
        decorated_book = BookDecorator.decorate book
        expect(decorated_book.feeds_as).to eq :associated
      end

      it 'raises error about specify class_name of association' do
        reader = create :reader
        create_list :rent, 10, reader_id: reader.id
        decorated_reader = ReaderDecorator.decorate reader
        expect { decorated_reader.rents }.to raise_error(
          errors['raises_error_about_specify_class_name_of_association']
        )
      end
    end
  end

  context 'with delegation' do
    context 'with Book' do
      let(:book) { create :book }
      let(:decorated_book) { described_class.decorate book }

      it 'delegates ID to object' do
        expect(decorated_book.id).to eq book.id
      end
    end
  end

  context 'with object methods' do
    context 'with Reader' do
      let(:reader) { create :reader }
      let(:decorated_reader) { described_class.decorate reader }

      it 'returns name' do
        expect { decorated_reader.name }.to raise_error(RuntimeError, errors['returns_name'])
      end

      it 'returns link' do
        expect { decorated_reader.link }.to raise_error(errors['returns_link_error'])
      end

      it 'returns model' do
        expect(decorated_reader.model).to eq reader
      end

      it 'returns has_many association' do
        expect(decorated_reader.associations(:has_many).map(&:name).should =~
               %i[feeds rents]).to be_truthy
      end

      it 'returns belongs_to association' do
        expect(decorated_reader.associations(:belongs_to).map(&:name).should =~ []).to be_truthy
      end

      it 'returns has_and_belongs_to_many association' do
        expect(decorated_reader.associations(:has_and_belongs_to_many).map(&:name).should =~ []).to be_truthy
      end

      it 'returns has_one association' do
        expect(decorated_reader.associations(:has_one).map(&:name).should =~ []).to be_truthy
      end
    end
  end
end
