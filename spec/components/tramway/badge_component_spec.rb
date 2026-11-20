# frozen_string_literal: true

require 'rails_helper'

describe Tramway::BadgeComponent, type: :component do
  it 'renders badge with the default neutral variant' do
    render_inline(described_class.new(text: 'Active'))

    expect(page).to have_css('span.tramway-badge.tramway-badge--secondary', text: 'Active')
  end

  context 'when a type is provided' do
    it 'renders badge with the mapped variant' do
      render_inline(described_class.new(text: 'Approved', type: :success))

      expect(page).to have_css('span.tramway-badge.tramway-badge--success', text: 'Approved')
    end
  end

  context 'when a custom color is provided' do
    it 'renders badge with the tinted fallback' do
      render_inline(described_class.new(text: 'Alert', color: :red))

      expect(page).to have_css('span.tramway-badge.tramway-badge--tint.tramway-tint--red', text: 'Alert')
    end
  end

  context 'when secondary type is provided' do
    it 'renders secondary badge classes' do
      render_inline(described_class.new(text: 'Draft', type: :secondary))

      expect(page).to have_css('span.tramway-badge.tramway-badge--secondary', text: 'Draft')
    end
  end

  context 'when inverse type is provided' do
    it 'renders ghost badge classes' do
      render_inline(described_class.new(text: 'Archived', type: :inverse))

      expect(page).to have_css('span.tramway-badge.tramway-badge--ghost', text: 'Archived')
    end
  end
end
