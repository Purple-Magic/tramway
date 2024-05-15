describe UserDecorator do
  let(:user) do
    create(:user).tap do |obj|
      create_list :post, 5, user: obj
    end
  end

  subject { described_class.decorate(user) }

  it 'responds to #posts' do
    expect(subject).to respond_to(:posts)
  end

  it 'returns posts' do
    expect(subject.posts.first).to be_a(PostDecorator)
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
