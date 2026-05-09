# frozen_string_literal: true

require 'rails_helper'

describe Tramway::BadgeComponent, type: :component do
  it 'renders badge with default dark shadcn-style styling' do
    render_inline(described_class.new(text: 'Active'))

    expect(page).to have_css('span', text: 'Active')
    expect(page.find('span', text: 'Active')[:class].split).to include(
      *%w[
        inline-flex items-center rounded-md border px-2.5 py-0.5 text-xs font-semibold transition-colors
        focus:outline-none focus:ring-2 focus:ring-zinc-400 focus:ring-offset-2 focus:ring-offset-zinc-950
        border-transparent bg-zinc-50 text-zinc-950 shadow hover:bg-zinc-200
      ]
    )
  end

  context 'when a type is provided' do
    it 'renders badge with mapped dark accent color' do
      render_inline(described_class.new(text: 'Approved', type: :success))

      expect(page).to have_css(
        "span.#{class_selector(%w[border-green-800 bg-green-900/30 text-green-400 hover:bg-green-900])}",
        text: 'Approved'
      )
    end
  end

  context 'when a custom color is provided' do
    it 'renders badge with explicit dark accent color' do
      render_inline(described_class.new(text: 'Alert', color: :red))

      expect(page).to have_css(
        "span.#{class_selector(%w[border-red-800 bg-red-900/30 text-red-400 hover:bg-red-900])}",
        text: 'Alert'
      )
    end
  end

  context 'when secondary type is provided' do
    it 'renders dark secondary badge classes' do
      render_inline(described_class.new(text: 'Draft', type: :secondary))

      expect(page).to have_css(
        "span.#{class_selector(%w[border-transparent bg-zinc-800 text-zinc-50 shadow hover:bg-zinc-800/80])}",
        text: 'Draft'
      )
    end
  end

  context 'when inverse type is provided' do
    it 'renders dark inverse badge classes' do
      render_inline(described_class.new(text: 'Archived', type: :inverse))

      expect(page).to have_css(
        "span.#{class_selector(%w[border-zinc-800 bg-zinc-950 text-zinc-50 shadow hover:bg-zinc-900])}",
        text: 'Archived'
      )
    end
  end
end
