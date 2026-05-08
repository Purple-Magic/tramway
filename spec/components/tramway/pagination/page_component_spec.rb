# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Pagination::PageComponent, type: :component do
  describe '#current_page_classes' do
    let(:component) { described_class.new(current_page: nil, url: '/users?page=1', remote: false, page: nil) }

    it 'uses hardcoded dark current-page classes' do
      expect(component.current_page_classes).to eq(
        'inline-flex h-10 items-center justify-center rounded-md border border-zinc-800 bg-zinc-800 px-3 py-2 ' \
        'text-sm font-medium text-zinc-50 shadow-inner'
      )
    end
  end
end
