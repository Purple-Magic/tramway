# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::ButtonComponent, type: :component do
  shared_examples 'button theme classes' do |theme_classes|
    context 'when text is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'View projects') }

      it 'renders button_to with defaults' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(theme_classes.fetch(:default))}[href='/projects']",
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

      expect(page).to have_css "a[href='/projects']", text: 'Open'
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

    context 'when path is a hash placeholder' do
      let(:component) { described_class.new(path: '#', text: 'View projects') }

      it 'renders a link_to element' do
        render_inline(component)

        expect(page).to have_css(
          "a[href='#'].#{class_selector(theme_classes.fetch(:link))}",
          text: 'View projects'
        )
      end
    end

    context 'when a semantic type is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'Celebrate', type: :love) }

      it 'renders button with mapped color' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(theme_classes.fetch(:semantic))}[href='/projects']",
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
          "a[href='/projects'][disabled='disabled'].#{class_selector(theme_classes.fetch(:disabled))}",
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
                      btn btn-primary flex flex-row font-semibold rounded-xl whitespace-nowrap items-center gap-1
                      shadow-md py-2 px-4 h-10 bg-gray-700 hover:bg-gray-800 text-white
                    ],
                    non_get: %w[
                      btn btn-primary flex flex-row font-semibold rounded-xl whitespace-nowrap items-center gap-1
                      shadow-md text-sm py-1 px-2 rounded extra-class bg-red-700 hover:bg-red-800 text-white
                      cursor-pointer
                    ],
                    link: %w[
                      btn btn-primary flex flex-row font-semibold rounded-xl whitespace-nowrap items-center gap-1
                      shadow-md py-2 px-4 h-10 bg-gray-700 hover:bg-gray-800 text-white px-1 h-fit w-fit
                    ],
                    semantic: %w[
                      bg-violet-700 hover:bg-violet-800 text-white
                    ],
                    disabled: %w[bg-gray-800 text-gray-500 shadow-inner]
  end

  context 'when rendering outside of a table cell' do
    it 'does not add stopPropagation onclick' do
      render_inline(described_class.new(path: '/projects', text: 'View projects'))

      expect(page).to have_css("a[href='/projects']", text: 'View projects')
      expect(page).to have_no_css("a[href='/projects'][onclick]")
    end
  end

  context 'with special cases' do
    it 'renders <a> tag' do
      render_inline(described_class.new(text: 'AGENTS.md (raw)',
                                        path: '/docs/api/AGENTS.md',
                                        type: :secondary,
                                        size: :small,
                                        options: { target: '_blank' }))

      expect(page).to have_css('a')
    end

    it 'renders <a> tag when path is ActiveRecord object' do
      article = Article.create!(title: 'Test Article', text: 'Content')

      render_inline(described_class.new(text: 'View Article', path: article))

      expect(page).to have_css('a')
    end

    it 'renders <a> tag when `Edit` path is provided' do
      render_inline(
        described_class.new(
          path: '/projects/236685d2-9684-48af-8aff-21fd31a4f865/payments/1/edit',
          type: :greed,
          size: :small
        ) do
          'Edit'
        end
      )

      expect(page).to have_css('a')
    end
  end
end
