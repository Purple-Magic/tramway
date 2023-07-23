# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tramway::Configs::Entity do
  let(:name) { :user }
  subject { described_class.new(name:) }

  describe '#initialize' do
    it 'sets the correct name' do
      expect(subject.name).to eq(name.to_s)
    end
  end

  describe '#routes' do
    it 'returns an OpenStruct object with index route' do
      expect(subject.routes).to be_an(OpenStruct)
      expect(subject.routes).to respond_to(:index)
    end

    let(:expected_route) do
      Rails.application.routes.url_helpers.public_send("#{name.to_s.pluralize}_path")
    end

    it 'sets the correct index route' do
      expect(subject.routes.index).to eq(expected_route)
    end
  end

  describe '#human_name' do
    it 'returns an OpenStruct object with single and plural human names' do
      expect(subject.human_name).to be_an(OpenStruct)
      expect(subject.human_name).to respond_to(:single)
      expect(subject.human_name).to respond_to(:plural)
    end

    let(:expected_single_name) { name.to_s.capitalize }
    let(:expected_plural_name) { name.to_s.pluralize.capitalize }

    it 'sets the correct single and plural human names' do
      expect(subject.human_name.single).to eq(expected_single_name)
      expect(subject.human_name.plural).to eq(expected_plural_name)
    end
  end
end
