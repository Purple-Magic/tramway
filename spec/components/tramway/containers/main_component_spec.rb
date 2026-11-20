# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Containers::MainComponent, type: :component do
  it 'keeps caller classes separated from the shared container classes' do
    render_inline(described_class.new(options: { class: 'md:pl-72 transition-all duration-300 ease-in-out' })) do
      'Content'
    end

    expect(page).to have_css 'main.tramway-main'
    expect(page).to have_css 'main.md\\:pl-72.transition-all.duration-300.ease-in-out'
  end
end
