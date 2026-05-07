# frozen_string_literal: true

require 'rails_helper'

describe Tramway::BadgeComponent, type: :component do
  shared_examples 'badge theme classes' do |theme_classes|
    it 'renders badge with default styling' do
      render_inline(described_class.new(text: 'Active'))

      expect(page).to have_css(
        "span.#{class_selector(theme_classes.fetch(:default))}",
        text: 'Active'
      )
    end

    context 'when a type is provided' do
      it 'renders badge with mapped color' do
        render_inline(described_class.new(text: 'Approved', type: :success))

        expect(page).to have_css(
          "span.#{class_selector(theme_classes.fetch(:type))}",
          text: 'Approved'
        )
      end
    end

    context 'when a custom color is provided' do
      it 'renders badge with explicit color' do
        render_inline(described_class.new(text: 'Alert', color: :red))

        expect(page).to have_css(
          "span.#{class_selector(theme_classes.fetch(:custom))}",
          text: 'Alert'
        )
      end
    end
  end

  context 'with classic theme' do
    around { |example| with_theme(:classic) { example.run } }

    it_behaves_like 'badge theme classes',
                    default: %w[
                      inline-flex items-center rounded-md px-2.5 py-0.5 text-xs font-semibold transition-colors
                      focus:outline-none focus:ring-2 focus:ring-zinc-950 focus:ring-offset-2 w-fit h-fit
                      border border-transparent bg-zinc-50 text-zinc-950
                    ],
                    type: %w[border border-transparent bg-zinc-50 text-zinc-950],
                    custom: %w[border border-transparent bg-red-600 text-white]
  end
end
