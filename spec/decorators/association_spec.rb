# frozen_string_literal: true

describe UserDecorator do
  subject { described_class.decorate(user) }

  context 'with existing posts' do
    let(:user) do
      create(:user).tap do |obj|
        create_list :post, 5, user: obj
      end
    end

    it 'responds to #posts' do
      expect(subject).to respond_to(:posts)
    end

    it 'returns posts' do
      expect(subject.posts.first).to be_a(PostDecorator)
    end
  end

  context 'with no posts' do
    let(:user) { create(:user) }

    it 'responds to #posts' do
      expect(subject).to respond_to(:posts)
    end

    it 'returns empty array' do
      expect(subject.posts).to eq []
    end
  end
end

describe PostDecorator do
  let(:post) { create :post }

  subject { described_class.decorate(post) }

  it 'responds to #posts' do
    expect(subject).to respond_to(:user)
  end

  it 'returns posts' do
    expect(subject.user).to be_a(UserDecorator)
  end
end
