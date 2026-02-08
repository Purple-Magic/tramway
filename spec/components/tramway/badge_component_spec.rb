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
                      flex px-3 py-1 text-sm font-semibold rounded-full w-fit h-fit bg-gray-700 text-gray-100 shadow-md
                    ],
                    type: %w[bg-green-700 text-green-100],
                    custom: %w[bg-red-700 text-red-100]
  end
end
