# frozen_string_literal: true

RSpec.describe AdminForm do
  context 'properties' do
    subject { described_class.new(user) }

    let(:user) { build :user }
    let(:fields) { %i[email first_name last_name role permissions] }

    describe 'properties field' do
      it 'returns an array with email and role' do
        expect(described_class.properties).to match_array(fields)
      end
    end

    describe 'setting up values' do
      it 'sets up values' do
        fields.map do |field|
          subject.public_send "#{field}=", 'somestr'

          expect(subject.send(field)).to eq 'somestr'
        end
      end
    end
  end

  context 'normalizes' do
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
