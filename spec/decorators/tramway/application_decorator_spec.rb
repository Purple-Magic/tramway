# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tramway::ApplicationDecorator do
  let(:errors) { YAML.load_file(Rails.root.join('..', 'yaml', 'errors.yml')).with_indifferent_access }
  it 'defined decorator class' do
    expect(defined?(described_class)).to be_truthy
  end

  it 'should initialize new decorated object' do
    obj = 'it can be any object'
    expect { described_class.new obj }.not_to raise_error(StandardError)
  end

  context 'Class check' do
    let(:class_methods) do
      described_class.methods -
        described_class.superclass.methods -
        bad_ass_monkey_patching_methods(source: :active_support) -
        bad_ass_monkey_patching_methods(source: %i[action_view helpers])
    end

    it 'class should have only this methods list' do
      expect(class_methods.should =~ %i[
        decorate_association
        decorate_associations
        define_main_association_method
        delegate_attributes
        list_attributes
        decorate
        model_class
        model_name
        show_attributes
        show_associations
        collections
        list_filters
      ]).to be_truthy
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

    context 'with TestModel' do
      it 'should have 10 items' do
        create_list :test_model, 10
        models = TestModel.limit(10)
        expect(described_class.decorate(models).count).to eq 10
      end

      it 'should decorate all items' do
        create_list :test_model, 10
        models = TestModel.limit(10)
        expect(described_class.decorate(models)).to all be_a(described_class)
      end

      it 'should decorate association models' do
        test_model = create :test_model
        create_list :association_model, 10, test_model_id: test_model.id
        decorated_test_model = TestModelDecorator.decorate test_model
        expect(decorated_test_model.association_models).to all be_a(AssociationModelDecorator)
      end

      it 'should create `association_as` method after decorating association' do
        test_model = create :test_model
        create_list :association_model, 10, test_model_id: test_model.id
        decorated_test_model = TestModelDecorator.decorate test_model
        expect(decorated_test_model.association_models_as).to eq :record
      end

      it 'should raise error about specify class_name of association' do
        test_model = create :test_model
        create_list :another_association_model, 10, test_model_id: test_model.id
        decorated_test_model = TestModelDecorator.decorate test_model
        expect { decorated_test_model.another_association_models }.to raise_error(
          "Please, specify `another_association_models` association class_name in TestModel model. For example: `has_many :another_association_models, class_name: 'AnotherAssociationModel'`"
        )
      end
    end
  end

  context 'Delegation checks' do
    context 'with TestModel' do
      let(:test_model) { create :test_model }
      let(:decorated_test_model) { described_class.decorate test_model }

      it 'delegates ID to object' do
        expect(decorated_test_model.id).to eq test_model.id
      end
    end
  end

  context 'Object methods checks' do
    context 'with TestModel' do
      let(:test_model) { create :test_model }
      let(:decorated_test_model) { described_class.decorate test_model }

      it 'returns name' do
        expect { decorated_test_model.name }.to raise_error(
          RuntimeError,
          'Please, implement `title` method in a Tramway::ApplicationDecorator or delegate it to TestModel'
        )
      end

      it 'returns link' do
        expect { decorated_test_model.link }.to(
          raise_error("Method `link` uses `file` attribute of the decorated object. If decorated object doesn't contain `file`, you shouldn't use `link` method.")
        )
      end

      it 'returns model' do
        expect(decorated_test_model.model).to eq test_model
      end

      it 'returns associations' do
        expect(decorated_test_model.associations(:has_many).map(&:name).should =~
               %i[association_models another_association_models]).to be_truthy
        expect(decorated_test_model.associations(:belongs_to).map(&:name).should =~ []).to be_truthy
        expect(decorated_test_model.associations(:has_and_belongs_to_many).map(&:name).should =~ []).to be_truthy
        expect(decorated_test_model.associations(:has_one).map(&:name).should =~ []).to be_truthy
      end
    end
  end
end
