# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Configs::Entities::Page do
  describe 'defaults' do
    subject { described_class.new(action: :custom_page) }

    it 'defaults member to false (a collection-level route)' do
      expect(subject.member).to be(false)
    end

    it 'defaults via to :get' do
      expect(subject.via).to eq(:get)
    end

    it 'defaults params to an empty array' do
      expect(subject.params).to eq([])
    end
  end

  describe 'custom page options' do
    subject do
      described_class.new(action: :export, member: true, via: %i[get post], params: [:format])
    end

    it 'accepts member: true' do
      expect(subject.member).to be(true)
    end

    it 'accepts an array of HTTP methods for via' do
      expect(subject.via).to eq(%i[get post])
    end

    it 'coerces params to symbols' do
      expect(subject.params).to eq([:format])
    end
  end
end
