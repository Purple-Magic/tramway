# frozen_string_literal: true

require 'rails_helper'
describe UserDecorator do
  subject(:decorated_object) { described_class.new(object) }

  let(:object) { create :user, :with_posts }

  describe '#published_posts' do
    it 'returns empty collection' do
      expect(decorated_object.published_posts).to be_empty
    end
  end
end
