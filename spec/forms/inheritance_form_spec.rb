# frozen_string_literal: true

RSpec.describe AdminForm do
  context 'properties' do
    let(:user) { build :user }
    subject { described_class.new(user) }

    let(:fields) { %i[email role permissions] }

    describe 'properties field' do
      it 'returns an array with email and role' do
        expect(AdminForm.properties).to contain_exactly(*fields)
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
end
