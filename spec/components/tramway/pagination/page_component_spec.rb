# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Pagination::PageComponent, type: :component do
  describe '#current_page_classes' do
    let(:component) { described_class.new(current_page: nil, url: '/users?page=1', remote: false, page: nil) }

    it 'uses the current page link primitive' do
      expect(component.current_page_classes).to eq(
        'tramway-pagination__link tramway-pagination__link--current'
      )
    end
  end
end
