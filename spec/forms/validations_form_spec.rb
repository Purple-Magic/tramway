# frozen_string_literal: true

require 'rails_helper'

describe 'Validations' do
  let(:user) { create :user }

  context 'when validating attributes' do
    it 'adds errors and skips save on invalid attributes' do
      form = UserForm.new(user)

      expect(user).not_to receive(:save)

      form.submit(email: 'invalid-email')

      expect(form.errors[:email]).to include('is invalid')
    end

    it 'allows nil values when allow_nil is true' do
      form = UserForm.new(user)

      expect(user).to receive(:save).and_return(true)

      form.submit(email: nil)

      expect(form.errors).to be_empty
    end
  end

  context 'with inheritance and extension' do
    it 'inherits validations from the UserForm class' do
      expect(AdminForm.validations.keys).to match_array(%i[email permissions first_name])
    end

    it 'applies its own validations in addition to inherited ones' do
      form = AdminForm.new(user)

      expect(user).not_to receive(:save)

      form.submit(permissions: nil)

      expect(form.errors[:permissions]).to include('is invalid')
    end
  end
end
