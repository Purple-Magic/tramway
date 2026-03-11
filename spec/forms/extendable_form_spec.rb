# frozen_string_literal: true

require 'rails_helper'

describe 'Extendable forms' do # rubocop:disable RSpec/DescribeClass
  let(:user) { create(:user, first_name: 'Pasha', last_name: 'Kalashnikov') }

  before do
    stub_const('ExtendedUserForm', Class.new(Tramway::BaseForm) do
      properties :email, :full_name

      def full_name=(value)
        first_name, last_name = value.split(' ', 2)

        object.first_name = first_name
        object.last_name = last_name
      end
    end)
  end

  describe '#assign' do
    it 'supports non-mapped properties through a custom setter' do
      ExtendedUserForm.new(user).assign(full_name: 'Asya Selezneva')

      expect(user.first_name).to eq('Asya')
      expect(user.last_name).to eq('Selezneva')
    end
  end

  describe '#submit' do
    it 'persists values from a non-mapped property setter' do
      form = ExtendedUserForm.new(user)

      expect(form.submit(full_name: 'Asya Selezneva')).to be(true)
      expect(user.reload.first_name).to eq('Asya')
      expect(user.last_name).to eq('Selezneva')
    end
  end
end
