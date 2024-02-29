# frozen_string_literal: true

describe Tramway::BaseForm do
  let(:user) { create(:user) }
  let(:form) { described_class.new(user) }

  describe '#update' do
    let(:attributes) { { email: 'updated@example.com' } }

    it 'updates the object with given attributes' do
      expect(user).to receive(:update).with(attributes).and_return(true)

      expect(form.update(attributes)).to be true
    end
  end

  describe '#destroy' do
    it 'destroys the object' do
      expect(user).to receive(:destroy)

      form.destroy
    end
  end
end
