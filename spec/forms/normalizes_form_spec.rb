# frozen_string_literal: true

describe 'Normalization' do
  let(:user) do
    create :user,
           first_name: 'Pasha',
           last_name: 'Kalashnikov',
           email: 'OriginalEmail@example.com',
           permissions: %i[create update]
  end

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

    context 'when normalizing attributes with apply_to_nil: true' do
      it 'applies normalization to nil values and saves attributes' do
        allow(nil).to receive(:strip).twice

        AdminForm.new(user).submit(first_name: nil, last_name: nil)

        expect(user.first_name).to eq 'Anonymous'
        expect(user.last_name).to eq 'Anonymous'
      end
    end

    context 'when normalizing attributes with apply_to_nil: false' do
      it 'applies normalization to nil values and saves attributes' do
        UserForm.new(user).submit(email: nil)

        expect(user.email).to be_nil
      end
    end
  end

  context 'with inheritance and extension' do
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
