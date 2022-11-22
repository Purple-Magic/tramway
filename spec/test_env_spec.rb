# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Testing environment' do
  describe 'working' do
    it 'should just run test' do
      expect(true).to be_truthy
    end
  end
end
