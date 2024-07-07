# frozen_string_literal: true

describe Tramway::BaseForm do
  let(:user) { create(:user) }
  let(:form) { described_class.new(user) }

  context 'default' do
    it 'does not contain update method' do
      expect(form).not_to respond_to(:update)
      expect(form).not_to respond_to(:update!)
    end

    it 'does not contain destroy method' do
      expect(form).not_to respond_to(:destroy)
    end
  end

  context 'when behave_as_ar' do
    before { described_class.behave_as_ar }

    describe '#update' do
      let(:attributes) { { email: 'updated@example.com' } }

      it 'updates the object with given attributes' do
        expect(user).to receive(:update).with(attributes).and_return(true)

        expect(form.update(attributes)).to be true
      end

      it 'updates the object with given attributes' do
        expect(user).to receive(:update!).with(attributes).and_return(true)

        expect(form.update!(attributes)).to be true
      end
    end

    describe '#destroy' do
      it 'destroys the object' do
        expect(user).to receive(:destroy)

        form.destroy
      end
    end
  end
end
