# frozen_string_literal: true

RSpec.describe Tramway::BaseForm do
  let(:user) { build(:user) }
  let(:form) { UserForm.new(user) }

  describe '#submit with normalization' do
    it 'normalizes email before saving' do
      params = { email: ' Example@Email.Com ' }

      expect(user).to receive(:email=).with('example@email.com')
      expect(user).to receive(:save).and_return(true)

      form.submit(params)
    end
  end

  context 'with normalization rule for non-existing attribute' do
    it 'ignores normalization for non-defined attributes' do
      params = { non_existing_attribute: ' some value ' }

      expect { form.submit(params) }.not_to raise_error
    end
  end
end
