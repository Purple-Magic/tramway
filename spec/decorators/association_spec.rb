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
  end
end
