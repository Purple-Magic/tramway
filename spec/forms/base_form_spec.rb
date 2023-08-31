# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tramway::BaseForm do
  let(:object) { create :user }
  subject { described_class.new(object) }

  describe '#initialize' do
    it 'assigns object' do
      expect(subject.object).to eq(object)
    end
  end

  describe '.property' do
    it 'adds the attribute to properties list and delegates to the object' do
      described_class.property(:email)
      expect(described_class.properties).to include(:email)
      expect(subject).to receive(:email).and_return('asya@purple-magic.com')
      expect(subject.email).to eq('asya@purple-magic.com')
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
      methods_to_delegate = %i[model_name to_key to_model errors attributes]

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
