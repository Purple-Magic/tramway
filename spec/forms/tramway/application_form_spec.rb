# frozen_string_literal: true

require 'rails_helper'

describe Tramway::ApplicationForm do
  it 'defined form class' do
    expect(defined?(described_class)).to be_truthy
  end

  it 'creates form object' do
    book = create :book
    book_form = described_class.new book
    expect(book_form).to be_a described_class
  end

  context 'when it has submit method' do
    it 'returns error if params is nil' do
      book = create :book
      book_form = described_class.new book
      params = ActionController::Parameters.new book: nil
      expect { book_form.submit(params[:book]) }.to(
        raise_error(RuntimeError, 'ApplicationForm::Params should not be nil')
      )
    end
  end

  context 'with properties' do
    it 'set form_properties' do
      book = create :book
      book_form = described_class.new book
      book_form.form_properties text: :default, enumerized: :default
      expect(book_form.properties).to eq text: :default, enumerized: :default
    end
  end

  context 'with associations' do
    context 'with setted class_name' do
      it 'adds new association to form' do
        class_name = 'TestingAssociationWithSettedClassName'
        Object.const_set(class_name, Class.new(described_class))
        class_name.constantize.associations :book
        reader = create :reader
        reader_form = class_name.constantize.new reader
        expect(reader_form).to respond_to('book=').with(1).argument
      end
    end

    context 'without setted class_name' do
      it 'adds new association to form' do
        class_name = 'TestingAnother2AssociationWithSettedClassName'
        Object.const_set(class_name, Class.new(described_class))
        class_name.constantize.associations :book
        reader = create :reader
        reader_form = class_name.constantize.new reader
        expect(reader_form).to respond_to('book=').with(1).argument
      end
    end

    context 'with full_class_name_association' do
      context 'with set class_name' do
        it 'return full_class_name_association' do
          class_name = 'NameAssociationAssociationWithSettedClassNameForm'
          Object.const_set(class_name, Class.new(described_class))
          class_name.constantize.new Rent.new
          class_name.constantize.associations :book
          expect(class_name.constantize.full_class_name_association(:book)).to eq Book
        end
      end

      context 'without set class_name' do
        it 'return full_class_name_association' do
          class_name = 'NameAssociation2AssociationWithSettedClassName'
          Object.const_set(class_name, Class.new(described_class))
          class_name.constantize.new Rent.new
          class_name.constantize.associations :book
          expect(class_name.constantize.full_class_name_association(:book)).to eq Book
        end
      end
    end
  end

  context 'when it has enumerized attributes' do
    it 'returns list of enumerized attributes' do
      class_name = 'TestingEnumerizedAttributesClassName'
      Object.const_set(class_name, Class.new(described_class))
      book = create :book
      class_name.constantize.new book
      expect(class_name.constantize.enumerized_attributes).to eq Book.enumerized_attributes
    end
  end

  context 'when it\'s about model' do
    context 'with existed object' do
      it 'returns model class name' do
        class_name = 'TestingModelClassName'
        Object.const_set(class_name, Class.new(described_class))
        book = create :book
        class_name.constantize.new book
        expect(class_name.constantize.model_class).to eq Book
      end
    end

    context 'without existed object' do
      it 'returns model class name' do
        class_name = 'BookForm'
        Object.const_set(class_name, Class.new(described_class))
        expect(class_name.constantize.model_class).to eq Book
      end

      it 'raises error because model doesn\'t exist' do
        class_name = 'NotExistedForm'
        Object.const_set(class_name, Class.new(described_class))
        class_name.constantize.class_variable_set :@@model_class, nil
        expect { class_name.constantize.model_class }.to raise_error(RuntimeError)
      end
    end
  end
end
