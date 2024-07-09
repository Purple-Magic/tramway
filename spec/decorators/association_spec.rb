# frozen_string_literal: true

# NOTE: this file contains tests about associations, so it's better to have the whole logic in one file
# rubocop:disable RSpec/MultipleDescribes
describe UserDecorator do
  subject(:decorated_object) { described_class.decorate(user) }

  context 'with existing posts' do
    let(:user) do
      create(:user).tap do |obj|
        create_list :post, 5, user: obj
      end
    end

    it 'responds to #posts' do
      expect(decorated_object).to respond_to(:posts)
    end

    it 'returns posts' do
      expect(decorated_object.posts.first).to be_a(PostDecorator)
    end
  end

  context 'with no posts' do
    let(:user) { create(:user) }

    it 'responds to #posts' do
      expect(decorated_object).to respond_to(:posts)
    end

    it 'returns empty array' do
      expect(decorated_object.posts).to eq []
    end
  end
end

describe PostDecorator do
  subject(:decorated_object) { described_class.decorate(post) }

  let(:post) { create :post }

  it 'responds to #posts' do
    expect(decorated_object).to respond_to(:user)
  end

  it 'returns posts' do
    expect(decorated_object.user).to be_a(UserDecorator)
  end
end
# rubocop:enable RSpec/MultipleDescribes
