# frozen_string_literal: true

describe 'Normalization' do
  let(:user) { create(:user, email: 'OriginalEmail@example.com', permissions: %i[create update]) }

  context 'when normalizing attributes' do
    it 'normalizes email' do
      UserForm.new(user).submit(email: ' Example@Email.Com ')

      expect(user.email).to eq 'example@email.com'
    end

    context 'when normalizing multiple attributes' do
      it 'normalizes email and name' do
        AdminForm.new(user).submit(first_name: ' Asya ', last_name: ' Selezneva ')

        expect(user.first_name).to eq 'Asya'
        expect(user.last_name).to eq 'Selezneva'
      end
    end

    context 'when normalizing attributes with apply_on_nil: true' do
      it 'applies normalization to nil values' do
        AdminForm.new(user).submit(first_name: nil, last_name: nil)

        expect(user.first_name).to be_nil
        expect(user.last_name).to be_nil
      end
    end

    context 'when normalizing attributes without apply_on_nil' do
      it 'does not apply normalization to nil values' do
        UserForm.new(user).submit(email: nil)

        expect(user.email).to eq nil
      end
    end
  end

  context 'inheritance and extension' do
    let(:admin_form) { AdminForm.new(user) }

    it 'inherits normalizations from the UserForm class' do
      admin_form.submit(email: ' Admin@Example.Com ')

      expect(user.email).to eq 'admin@example.com'
    end

    it 'applies its own normalizations in addition to inherited ones' do
      admin_form.submit(permissions: 'create,update')

      expect(user.permissions).to eq %w[create update]
    end
  end
end
