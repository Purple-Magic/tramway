# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::NavbarComponent, type: :component do
  context 'with title checks' do
    it 'renders title' do
      render_inline(described_class.new(title: 'Purple Magic'))

      expect(page).to have_text 'Purple Magic'
    end
  end

  context 'with items checks' do
    it 'renders left items' do
      render_inline(described_class.new(left_items: ["<a href='/test'>Test</a>"]))

      expect(page).to have_css 'nav .flex ul.flex.items-center.space-x-4'
    end

    it 'renders right items' do
      render_inline(described_class.new(right_items: ["<a href='/test'>Test</a>"]))

      expect(page).to have_css 'nav ul.flex.items-center.space-x-4'
    end

    it 'renders left and right items' do
      links = ["<a href='/test'>Test</a>"]

      render_inline(described_class.new(right_items: links, left_items: links))

      expect(page).to have_css 'nav .flex ul.flex.items-center.space-x-4'
      expect(page).to have_css 'nav ul.flex.items-center.space-x-4'
    end
  end

  context 'with background checks' do
    it 'renders navbar with default colors' do
      render_inline(described_class.new)

      expect(page).to have_css 'nav.bg-purple-700'
    end

    it 'renders navbar with named color and default intensity' do
      color = Tailwinds::NavbarComponent::CSS_COLORS.sample

      render_inline(described_class.new(background: { color: }))

      expect(page).to have_css "nav.bg-#{color}-700"
    end

    it 'renders navbar with named color and intensity' do
      color = Tailwinds::NavbarComponent::CSS_COLORS.sample
      intensity = rand(Tailwinds::NavbarComponent::MIN_INTENSITY..Tailwinds::NavbarComponent::MAX_INTENSITY)

      render_inline(described_class.new(background: { color:, intensity: }))

      expect(page).to have_css "nav.bg-#{color}-#{intensity}"
    end

    it 'renders navbar with hex color' do
      color = "##{SecureRandom.hex(3)}"

      render_inline(described_class.new(background: { color: }))

      # NOTE: we need it because this line returns error, `[` is not expected in selectors
      # expect(page).to have_css "nav.bg-[#{color}]"

      navbar_class = page.native.children[1].children[0].children[0].attribute_nodes[0].value
      expect(navbar_class).to include("bg-[#{color}]")
    end
  end
end
