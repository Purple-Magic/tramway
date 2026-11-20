# frozen_string_literal: true

require 'rails_helper'

describe Tramway::TooltipComponent, type: :component do
  it 'renders hover tooltip by default' do
    render_inline(described_class.new(text: 'More details')) do
      'Help'
    end

    expect(page).to have_css('div.tramway-tooltip', text: 'Help')
    expect(page).to have_css('div.tramway-tooltip__trigger.tramway-tooltip__trigger--hover', text: 'Help')
    expect(page.find("span[role='tooltip']", text: 'More details', visible: :all)[:class].split).to include(
      *%w[tramway-tooltip__panel tramway-tooltip__panel--hover]
    )
  end

  it 'renders onclick tooltip with a stimulus trigger' do
    render_inline(described_class.new(text: 'Open details', event: :onclick)) do
      'Toggle'
    end

    expect(page).to have_css(
      "div.tramway-tooltip[data-controller='tramway-tooltip']" \
      "[data-action='click@window->tramway-tooltip#closeOnClickOutside']"
    )
    expect(page).to have_css(
      "div.tramway-tooltip__trigger--click[data-action='click->tramway-tooltip#toggle']",
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
