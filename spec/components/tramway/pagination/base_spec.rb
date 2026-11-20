# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Pagination::Base, type: :component do
  describe '#pagination_classes' do
    let(:component) { described_class.new(current_page: nil, url: '/users?page=2', remote: false) }

    it 'uses the pagination link primitive' do
      expect(component.pagination_classes(klass: 'next tramway-pagination__link--wide')).to eq(
        'tramway-pagination__link next tramway-pagination__link--wide'
      )
    end
  end
end
