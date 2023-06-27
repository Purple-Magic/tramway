# frozen_string_literal: true

require 'rails_helper' # or 'spec_helper' if not using Rails

RSpec.describe Tramway::BaseDecorator do
  let(:object) { double('object') }
  let(:context) { double('context') }
  subject { described_class.new(object, context) }

  describe '#initialize' do
    it 'assigns object and context' do
      expect(subject.object).to eq(object)
      expect(subject.context).to eq(context)
    end
  end

  describe '#render' do
    let(:args) { %i[arg1 arg2] }

    it 'calls the context render method with the provided arguments' do
      expect(context).to receive(:render).with(*args, layout: false)
      subject.render(*args)
    end
  end

  describe '.decorate' do
    context 'when object_or_array is an ActiveRecord::Relation' do
      let(:relation) do
        create_list :user, 5
        User.all
      end

      it 'calls decorate_collection with the collection and context' do
        expect(Tramway::Decorators::CollectionDecorators).to receive(:decorate_collection).with(collection: relation,
                                                                                                context:)
        described_class.decorate(relation, context)
      end
    end

    context 'when object_or_array is an Array' do
      let(:relation) do
        create_list :user, 5
        User.all.to_a
      end

      it 'calls decorate_collection with the collection and context' do
        expect(Tramway::Decorators::CollectionDecorators).to receive(:decorate_collection).with(collection: relation,
                                                                                                context:)
        described_class.decorate(relation, context)
      end
    end

    context 'when object_or_array is not an ActiveRecord::Relation' do
      let(:object) { double('object') }

      it 'initializes a new decorator with the object and context' do
        expect(described_class).to receive(:new).with(object, context)
        described_class.decorate(object, context)
      end
    end
  end

  describe '.delegate_attributes' do
    it 'delegates the specified attributes to the object' do
      expect(described_class).to receive(:delegate).with(:id, to: :object)
      described_class.delegate_attributes(:id)
    end
  end

  describe '#to_partial_path' do
    let(:object_class) { double('object_class', name: 'MyClass') }
    before { allow(object).to receive(:class).and_return(object_class) }

    it 'returns the correct partial path based on the object class' do
      expect(subject.to_partial_path).to eq('my_classes/my_class')
    end
  end

  describe '#to_param' do
    let(:id) { 123 }
    before { allow(object).to receive(:id).and_return(id) }

    it 'returns the string representation of the object id' do
      expect(subject.to_param).to eq(id.to_s)
    end
  end
end
