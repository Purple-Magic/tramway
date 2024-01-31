# frozen_string_literal: true

RSpec.describe AdminForm do
  context 'class methods' do
    describe '.properties' do
      it 'returns an array with email and role' do
        expect(AdminForm.properties).to contain_exactly(:email, :role)
      end
    end
  end

  context 'instance methods' do
    let(:user) { build :user }
    subject { described_class.new(user) }

    describe 'accessors for properties' do
      it 'allows reading and writing for email' do
        subject.email = 'admin@example.com'

        expect(subject.email).to eq 'admin@example.com'
      end

      it 'allows reading and writing for role' do
        subject.role = 'superadmin'

        expect(subject.role).to eq 'superadmin'
      end
    end

    describe 'accessors for AdminForm specific properties' do
      before do
        AdminForm.properties :permissions
      end

      it 'allows reading and writing for permissions' do
        subject.permissions = 'edit_users'

        expect(subject.permissions).to eq 'edit_users'
      end
    end
  end
end
