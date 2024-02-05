# frozen_string_literal: true

RSpec.describe UserForm do
  context 'with persisted object' do
    let(:object) { create :user }
    subject { described_class.new(object) }

    describe '#initialize' do
      it 'assigns object' do
        is_expected.to have_attributes object:
      end
    end

    describe '.property' do
      it 'adds the attribute to properties list and delegates to the object' do
        described_class.property(:email)
        expect(described_class.properties).to include(:email)

        is_expected.to receive(:email).and_return('asya@purple-magic.com')
        is_expected.to have_attributes(email: 'asya@purple-magic.com')
      end
    end

    describe '#submit' do
      let(:params) { { email: 'asya@purple-magic.com' } }

      it 'updates object attributes and saves it' do
        expect(object).to receive(:save).and_return(true)
        expect(object).to receive(:reload)

        subject.submit(params)
      end
    end

    describe '#submit!' do
      let(:params) { { email: 'asya@purple-magic.com' } }

      it 'updates object attributes and saves it with validation' do
        expect(object).to receive(:save!).and_return(true)
        expect(object).to receive(:reload)
        subject.submit!(params)
      end
    end

    context 'method delegation' do
      it 'delegates certain methods to the object' do
        methods_to_delegate = %i[id model_name to_key to_model errors attributes]

        methods_to_delegate.each do |method|
          expect(object).to receive(method)

          subject.public_send(method)
        end
      end
    end

    describe 'method_missing' do
      it 'raises NoMethodError for other cases' do
        expect { subject.unknown_method }.to raise_error(NoMethodError)
      end
    end
  end

  context 'with not persisted' do\
    let(:object) { build :user }
    let(:form) { described_class.new(object) }

    describe '#submit' do
      let(:params) { { email: 'asya@purple-magic.com' } }

      it 'updates object attributes and saves it' do
        expect(object).to receive(:save).and_return(false)
        expect(object).not_to receive(:reload)

        form.submit(params)
      end
    end

    describe '#submit!' do
      let(:params) { { email: 'asya@purple-magic.com' } }

      it 'updates object attributes and saves it with validation' do
        expect(object).to receive(:save!).and_return(false)
        expect(object).not_to receive(:reload)

        form.submit!(params)
      end
    end
  end

  context 'with non-existing attributes' do
    let(:user_email) { 'asya@purple-magic.com' }
    let(:object) { create :user, email: user_email }
    let(:form) { described_class.new(object) }

    describe '#submit' do
      let(:params) { { password: '123456' } }

      it 'does not update non-existing attributes' do
        expect(object).to receive(:save).and_return(true)
        expect(object).to receive(:reload)

        form.submit(params)

        expect(object.email).to eq user_email
      end
    end
  end
end
