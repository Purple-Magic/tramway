# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::ButtonComponent, type: :component do
  context 'when text is provided' do
    let(:component) { described_class.new(path: '/projects', text: 'View projects') }

    it 'renders button_to with defaults' do
      render_inline(component)

      expect(page).to have_css(
        "form[action='/projects'] button.btn.btn-primary.flex.flex-row.py-2.px-4.cursor-pointer." \
        'bg-gray-600.hover\\:bg-gray-800.text-gray-300',
        text: 'View projects'
      )
    end
  end

  context 'when non-get method is provided' do
    let(:component) do
      described_class.new(
        path: '/projects/1',
        text: 'Delete',
        method: :delete,
        color: :red,
        size: :small,
        options: { class: 'extra-class', data: { turbo_confirm: 'Are you sure?' } }
      )
    end

    it 'renders button_to with merged options' do
      render_inline(component)

      expect(page).to have_css(
        "form[action='/projects/1'] button.text-sm.py-1.px-2." \
        "extra-class[data-turbo-confirm='Are you sure?']",
        text: 'Delete'
      )
    end
  end

  it 'renders block content when text is not provided' do
    render_inline(described_class.new(path: '/projects')) do
      'Open'
    end

    expect(page).to have_css "form[action='/projects'] button", text: 'Open'
  end

  context 'when rendering a link explicitly' do
    let(:component) { described_class.new(path: '/projects', text: 'View projects', link: true) }

    it 'renders a link_to element' do
      render_inline(component)

      expect(page).to have_css(
        "a[href='/projects'].btn.btn-primary.flex.flex-row.py-2.px-4." \
        'bg-gray-600.hover\\:bg-gray-800.text-gray-300.px-1.h-fit',
        text: 'View projects'
      )
    end
  end

  context 'when a semantic type is provided' do
    let(:component) { described_class.new(path: '/projects', text: 'Celebrate', type: :love) }

    it 'renders button with mapped color' do
      render_inline(component)

      expect(page).to have_css(
        "form[action='/projects'] button.bg-violet-600.hover\\:bg-violet-800",
        text: 'Celebrate'
      )
    end
  end
end
