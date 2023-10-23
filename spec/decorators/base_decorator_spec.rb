# frozen_string_literal: true

RSpec.describe Tramway::BaseDecorator do
  let(:object) { double('object') }
  let(:decorator) { Tramway::BaseDecorator }
  subject { described_class.new(object) }

  describe '#initialize' do
    it 'assigns object' do
      expect(subject.object).to eq(object)
    end
  end

  describe '#render' do
    let(:args) { %i[arg1 arg2] }

    it 'calls the ActionController::Base.render method with the provided arguments' do
      expect(ActionController::Base).to receive(:render).with(*args, { layout: false })
      subject.render(*args, layout: false)
    end
  end

  describe '.decorate' do
    context 'when object_or_array is an ActiveRecord::Relation' do
      let(:relation) do
        create_list :user, 5
        User.all
      end

      it 'calls decorate_collection with the collection' do
        expect(Tramway::Decorators::CollectionDecorators).to receive(:decorate_collection)
          .with(collection: relation, decorator:)
        described_class.decorate(relation)
      end
    end

    context 'when object_or_array is an Array' do
      let(:relation) do
        create_list :user, 5
        User.all.to_a
      end

      it 'calls decorate_collection with the collection' do
        expect(Tramway::Decorators::CollectionDecorators).to receive(:decorate_collection)
          .with(collection: relation, decorator:)
        described_class.decorate(relation)
      end
    end

    context 'when object_or_array is not an ActiveRecord::Relation' do
      let(:object) { double('object') }

      it 'initializes a new decorator with the object' do
        expect(described_class).to receive(:new).with(object)
        described_class.decorate(object)
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
