# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::ButtonComponent, type: :component do
  shared_examples 'button theme classes' do |theme_classes|
    context 'when text is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'View projects') }

      it 'renders button_to with defaults' do
        render_inline(component)

        expect(page).to have_css(
          "form[action='/projects'] button.#{class_selector(theme_classes.fetch(:default))}",
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
          "form[action='/projects/1'] button.#{class_selector(theme_classes.fetch(:non_get))}" \
          "[data-turbo-confirm='Are you sure?']",
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
          "a[href='/projects'].#{class_selector(theme_classes.fetch(:link))}",
          text: 'View projects'
        )
      end
    end

    context 'when a semantic type is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'Celebrate', type: :love) }

      it 'renders button with mapped color' do
        render_inline(component)

        expect(page).to have_css(
          "form[action='/projects'] button.#{class_selector(theme_classes.fetch(:semantic))}",
          text: 'Celebrate'
        )
      end
    end

    context 'when disabled: true is provided in options' do
      let(:component) do
        described_class.new(path: '/projects', text: 'Celebrate', type: :love, options: { disabled: true })
      end

      it 'renders button with disabled styles' do
        render_inline(component)

        expect(page).to have_css(
          "form[action='/projects'] button[disabled='disabled'].#{class_selector(theme_classes.fetch(:disabled))}",
          text: 'Celebrate'
        )
      end
    end

    context 'when rendering a link by params' do
      let(:path) { '/projects?resource_id=1' }
      let(:component) { described_class.new(path:, text: 'View projects') }

      it 'renders a link_to element' do
        render_inline(component)

        expect(page).to have_css(
          "a[href='#{path}'].#{class_selector(theme_classes.fetch(:link))}",
          text: 'View projects'
        )
      end
    end
  end

  context 'with classic theme' do
    around { |example| with_theme(:classic) { example.run } }

    it_behaves_like 'button theme classes',
                    default: %w[
                      btn btn-primary flex flex-row font-bold rounded-sm whitespace-nowrap items-center gap-1
                      py-2 px-4 h-10 bg-gray-600 hover:bg-gray-800 text-gray-300 cursor-pointer
                    ],
                    non_get: %w[
                      text-sm py-1 px-2 extra-class bg-red-600 hover:bg-red-800 text-gray-300
                    ],
                    link: %w[
                      btn btn-primary flex flex-row font-bold rounded-sm whitespace-nowrap items-center gap-1
                      py-2 px-4 h-10 bg-gray-600 hover:bg-gray-800 text-gray-300 px-1 h-fit w-fit
                    ],
                    semantic: %w[bg-violet-600 hover:bg-violet-800],
                    disabled: %w[bg-gray-400 text-gray-100]
  end

  context 'with neomorphism theme' do
    around { |example| with_theme(:neomorphism) { example.run } }

    it_behaves_like 'button theme classes',
                    default: %w[
                      btn btn-primary flex flex-row font-semibold rounded-xl whitespace-nowrap items-center gap-1
                      shadow-md py-2 px-4 h-10 bg-gray-200 hover:bg-gray-300 text-gray-800 cursor-pointer
                      dark:bg-gray-700 dark:hover:bg-gray-600 dark:text-gray-100
                    ],
                    non_get: %w[
                      text-sm py-1 px-2 extra-class bg-red-200 hover:bg-red-300 text-red-800
                      dark:bg-red-700 dark:hover:bg-red-600 dark:text-red-100
                    ],
                    link: %w[
                      btn btn-primary flex flex-row font-semibold rounded-xl whitespace-nowrap items-center gap-1
                      shadow-md py-2 px-4 h-10 bg-gray-200 hover:bg-gray-300 text-gray-800 px-1 h-fit w-fit
                      dark:bg-gray-700 dark:hover:bg-gray-600 dark:text-gray-100
                    ],
                    semantic: %w[
                      bg-violet-200 hover:bg-violet-300 text-violet-800 dark:bg-violet-700 dark:hover:bg-violet-600
                      dark:text-violet-100
                    ],
                    disabled: %w[bg-gray-200 text-gray-400 shadow-inner dark:bg-gray-800 dark:text-gray-500]
  end

  context 'when rendering outside of a table cell' do
    it 'does not add stopPropagation onclick' do
      render_inline(described_class.new(path: '/projects', text: 'View projects'))

      expect(page).to have_css("form[action='/projects'] button", text: 'View projects')
      expect(page).to have_no_css("form[action='/projects'] button[onclick]")
    end
  end
end
