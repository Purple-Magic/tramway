# frozen_string_literal: true

shared_examples 'Decorate Collection' do
  it 'calls decorate_collection with the collection' do
    expect(Tramway::Decorators::CollectionDecorators).to receive(:decorate_collection)
      .with(collection: relation, decorator:)
    described_class.decorate(relation)
  end
end

RSpec.describe Tramway::BaseDecorator do
  subject(:decorated_object) { described_class.new(object) }

  let(:object) { User.first }
  let(:decorator) { described_class }

  describe '#initialize' do
    it 'assigns object' do
      expect(decorated_object.object).to eq(object)
    end
  end

  describe '#render' do
    let(:args) { %i[arg1 arg2] }

    it 'calls the ActionController::Base.render method with the provided arguments' do
      expect(ActionController::Base).to receive(:render).with(*args, { layout: false })
      decorated_object.render(*args, layout: false)
    end
  end

  describe '.decorate' do
    context 'when object_or_array is an ActiveRecord::Relation' do
      let(:relation) do
        create_list :user, 5
        User.all
      end

      include_examples 'Decorate Collection'
    end

    context 'when object_or_array is an Array' do
      let(:relation) do
        create_list :user, 5
        User.all.to_a
      end

      include_examples 'Decorate Collection'
    end

    context 'when object_or_array is an ActiveRecord::Relation by association' do
      let(:relation) do
        user = create :user
        create_list(:post, 5, user:)

        user.reload
        user.posts
      end

      include_examples 'Decorate Collection'
    end

    context 'when object_or_array is an ActiveRecord::AssociationRelation' do
      let(:relation) do
        user = create :user
        create_list(:post, 5, user:)

        user.reload
        user.posts.order(id: :asc)
      end

      include_examples 'Decorate Collection'
    end

    context 'when object_or_array is not an ActiveRecord::Relation' do
      let(:object) { instance_double(User) }

      it 'initializes a new decorator with the object' do
        expect(described_class).to receive(:new).with(object)

        described_class.decorate(object)
      end
    end

    context 'when object is nil' do
      let(:object) { nil }

      it 'returns nil' do
        expect(described_class.decorate(object)).to be_nil
      end
    end
  end

  describe '.delegate_attributes' do
    it 'delegates the specified attributes to the object' do
      expect(described_class).to receive(:delegate).with(:id, to: :object)
      described_class.delegate_attributes(:id)
    end
  end

  describe '#to_param' do
    let(:id) { 123 }

    before { allow(object).to receive(:id).and_return(id) }

    it 'returns the string representation of the object id' do
      expect(decorated_object.to_param).to eq(id.to_s)
    end
  end
end
