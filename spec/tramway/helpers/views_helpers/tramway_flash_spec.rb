# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'
require 'tramway/helpers/views_helper'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_flash' do
    it 'renders dark shadcn-style flash classes with resolved semantic accent' do
      fragment = view.tramway_flash text: 'Saved!', type: :success
      flash_classes = %w[
        pointer-events-auto opacity-100 rounded-md border bg-zinc-950 px-4 py-3 text-sm text-zinc-50
        shadow-lg border-green-800 text-green-400
      ]

      expect(fragment).to have_css(
        ".flash.#{class_selector(flash_classes)}",
        text: 'Saved!'
      )
    end

    it 'renders dark default flash classes without depending on theme' do
      with_theme(:unknown) do
        fragment = view.tramway_flash text: 'Saved!', type: :default

        expect(fragment).to have_css('.flash.bg-zinc-950.border-zinc-800.text-zinc-50', text: 'Saved!')
      end
    end

    it 'applies custom HTML options to the container' do
      fragment = view.tramway_flash(text: 'Beep!', type: :warning)

      expect(fragment).to have_css('.fixed.top-4.right-4.z-50.flex.w-fit.max-w-sm.flex-col.gap-2.pointer-events-none')
    end

    it 'renders compact title typography' do
      fragment = view.tramway_flash(text: 'Beep!', type: :warning)

      expect(fragment).to have_css('.text-sm.font-medium.leading-6', text: 'Beep!')
    end
  end
end
