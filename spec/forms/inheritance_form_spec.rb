# frozen_string_literal: true

require 'rails_helper'
# NOTE: AdminForm is a dummy class, so there is no reason to store these tests following name conventions
# rubocop:disable RSpec/SpecFilePathFormat
describe AdminForm do
  context 'when properties' do
    subject(:form_object) { described_class.new(user) }

    let(:user) { build :user }
    let(:fields) { %i[email first_name last_name role permissions avatar country personal_info] }

    describe 'properties field' do
      it 'returns an array with email and role' do
        expect(described_class.properties).to match_array(fields)
      end
    end

    describe 'setting up values' do
      it 'sets up values' do
        fields.map do |field|
          form_object.public_send "#{field}=", 'somestr'

          expect(form_object.send(field)).to eq 'somestr'
        end
      end
    end
  end

  context 'when normalizes' do
    subject { described_class.new(user) }

    let(:user) { build :user }
    let(:fields) { %i[email first_name last_name permissions] }

    describe 'properties field' do
      it 'returns an array with email and role' do
        expect(described_class.normalizations.keys).to match_array(fields)
      end
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
