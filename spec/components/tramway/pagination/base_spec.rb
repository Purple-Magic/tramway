# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Pagination::Base, type: :component do
  describe '#pagination_classes' do
    let(:component) { described_class.new(current_page: nil, url: '/users?page=2', remote: false) }

    it 'uses hardcoded dark shadcn-style classes' do
      expect(component.pagination_classes(klass: 'next hidden sm:flex')).to include(
        'inline-flex',
        'rounded-md',
        'border-zinc-800',
        'bg-zinc-950',
        'text-zinc-100',
        'hover:bg-zinc-800',
        'focus-visible:ring-zinc-400',
        'next hidden sm:flex'
      )
    end
  end
end
