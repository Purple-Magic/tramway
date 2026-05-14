# frozen_string_literal: true

require 'rails_helper'

describe Tramway::TooltipComponent, type: :component do
  it 'renders hover tooltip by default' do
    render_inline(described_class.new(text: 'More details')) do
      'Help'
    end

    expect(page).to have_css('div.relative.inline-flex.w-fit', text: 'Help')
    expect(page).to have_css('div.peer.inline-flex.w-fit', text: 'Help')
    expect(page.find("span[role='tooltip']", text: 'More details', visible: :all)[:class].split).to include(
      *%w[
        absolute bottom-full left-1/2 z-50 mb-2 w-max min-w-40 max-w-sm -translate-x-1/2 rounded-md border
        border-zinc-800 bg-zinc-950 px-2.5 py-1.5 text-xs font-medium leading-5 text-zinc-50 shadow-lg
        pointer-events-none invisible opacity-0 transition-opacity peer-hover:visible peer-hover:opacity-100
      ]
    )
  end

  it 'renders onclick tooltip with a stimulus trigger' do
    render_inline(described_class.new(text: 'Open details', event: :onclick)) do
      'Toggle'
    end

    expect(page).to have_css(
      "div.relative.inline-flex.w-fit[data-controller='tramway-tooltip']" \
      "[data-action='click@window->tramway-tooltip#closeOnClickOutside']"
    )
    expect(page).to have_css(
      "div.inline-flex.w-fit.cursor-pointer[data-action='click->tramway-tooltip#toggle']",
      text: 'Toggle'
    )
  end

  it 'renders onclick tooltip panel as a stimulus target' do
    render_inline(described_class.new(text: 'Open details', event: :onclick)) do
      'Toggle'
    end

    expect(page).to have_css(
      "span[role='tooltip'].hidden[data-tramway-tooltip-target='panel']",
      text: 'Open details',
      visible: :all
    )
  end

  it 'merges wrapper options' do
    render_inline(described_class.new(text: 'More details', options: { class: 'ml-4', id: 'help-tooltip' })) do
      'Help'
    end

    expect(page).to have_css('div#help-tooltip.ml-4', text: 'Help')
  end

  it 'raises an error for unknown events' do
    expect do
      render_inline(described_class.new(text: 'More details', event: :focus)) { 'Help' }
    end.to raise_error(ArgumentError, 'Invalid event: focus. Valid events are :hover, :onclick.')
  end
end
