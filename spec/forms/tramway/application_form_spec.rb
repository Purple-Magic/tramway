# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tramway::ApplicationForm do
  it 'defined form class' do
    expect(defined?(described_class)).to be_truthy
  end

  it 'creates form object' do
    test_model = create :test_model
    test_model_form = described_class.new test_model
    expect(test_model_form).to be_a described_class
  end

  context 'Submit' do
    it 'returns error if params is nil' do
      test_model = create :test_model
      test_model_form = described_class.new test_model
      params = ActionController::Parameters.new test_model: nil
      expect { test_model_form.submit(params[:test_model]) }.to(
        raise_error(RuntimeError, 'ApplicationForm::Params should not be nil')
      )
    end
  end

  context 'Properties' do
    it 'set form_properties' do
      test_model = create :test_model
      test_model_form = described_class.new test_model
      test_model_form.form_properties text: :default, enumerized: :default
      expect(test_model_form.properties).to eq text: :default, enumerized: :default
    end
  end

  context 'Associations' do
    context 'with setted class_name' do
      it 'adds new association to form' do
        class_name = 'TestingAssociationWithSettedClassName'
        Object.const_set(class_name, Class.new(described_class))
        class_name.constantize.associations :test_model
        association_model = create :association_model
        association_model_form = class_name.constantize.new association_model
        expect(association_model_form).to respond_to('test_model=').with(1).argument
      end
    end

    context 'without setted class_name' do
      it 'adds new association to form' do
        class_name = 'TestingAnother2AssociationWithSettedClassName'
        Object.const_set(class_name, Class.new(described_class))
        class_name.constantize.associations :test_model
        association_model = create :another2_association_model
        association_model_form = class_name.constantize.new association_model
        expect(association_model_form).to respond_to('test_model=').with(1).argument
      end
    end

    context 'full_class_name_association' do
      context 'with setted class_name' do
        it 'return full_class_name_association' do
          class_name = 'NameAssociationAssociationWithSettedClassName'
          Object.const_set(class_name, Class.new(described_class))
          class_name.constantize.associations :test_model
          expect(class_name.constantize.full_class_name_association(:test_model)).to eq TestModel
        end
      end

      context 'without setted class_name' do
        it 'return full_class_name_association' do
          class_name = 'NameAssociation2AssociationWithSettedClassName'
          Object.const_set(class_name, Class.new(described_class))
          class_name.constantize.associations :test_model
          expect(class_name.constantize.full_class_name_association(:test_model)).to eq TestModel
        end
      end
    end
  end

  context 'Enumerized' do
    it 'returns list of enumerized attributes' do
      class_name = 'TestingEnumerizedAttributesClassName'
      Object.const_set(class_name, Class.new(described_class))
      test_model = create :test_model
      class_name.constantize.new test_model
      expect(class_name.constantize.enumerized_attributes).to eq TestModel.enumerized_attributes
    end
  end

  context 'Model' do
    context 'with existed object' do
      it 'returns model class name' do
        class_name = 'TestingModelClassName'
        Object.const_set(class_name, Class.new(described_class))
        test_model = create :test_model
        class_name.constantize.new test_model
        expect(class_name.constantize.model_class).to eq TestModel
      end
    end

    context 'without existed object' do
      it 'returns model class name' do
        class_name = 'TestModelForm'
        Object.const_set(class_name, Class.new(described_class))
        expect(class_name.constantize.model_class).to eq TestModel
      end

      it 'raises error because model doesn\'t exist' do
        class_name = 'NotExistedForm'
        Object.const_set(class_name, Class.new(described_class))
        class_name.constantize.class_variable_set :@@model_class, nil
        expect { class_name.constantize.model_class }.to raise_error
      end
    end
  end
end
