# frozen_string_literal: true

require 'rails_helper'

describe Tramway::ButtonComponent, type: :component do
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
          ".extra-class[data-turbo-confirm='Are you sure?']",
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

    context 'when inverse type is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'Invert', type: :inverse) }

      it 'renders button with inverse default colors and matching border' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(theme_classes.fetch(:inverse))}[href='/projects']",
          text: 'Invert'
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

    context 'when tooltip is provided' do
      let(:component) do
        described_class.new(
          path: '/projects',
          text: 'View projects',
          tooltip: { text: 'Open projects', event: :hover }
        )
      end

      it 'wraps button with a hover tooltip' do
        render_inline(component)

        expect(page).to have_css('div.relative.inline-flex.w-fit')
        expect(page).to have_css('div.peer.inline-flex.w-fit')
        expect(page).to have_css(
          "a.#{class_selector(theme_classes.fetch(:default))}[href='/projects']",
          text: 'View projects'
        )
        expect(page).to have_css("span[role='tooltip']", text: 'Open projects', visible: :all)
      end
    end

    context 'when onclick tooltip is provided' do
      let(:component) do
        described_class.new(
          path: '/projects',
          text: 'View projects',
          tooltip: { text: 'Open projects', event: :onclick }
        )
      end

      it 'wraps button with an onclick tooltip' do
        render_inline(component)

        expect(page).to have_css("div[data-controller='tramway-tooltip']")
        expect(page).to have_css("div[data-action='click->tramway-tooltip#toggle']")
        expect(page).to have_css("span[role='tooltip'].hidden[data-tramway-tooltip-target='panel']",
                                 text: 'Open projects',
                                 visible: :all)
      end
    end

    context 'when tooltip is not a hash with text and event' do
      it 'raises an error' do
        expect do
          render_inline(described_class.new(path: '/projects', text: 'View projects', tooltip: 'Open projects'))
        end.to raise_error(ArgumentError, 'Tooltip must be a hash with :text and :event keys.')
      end
    end
  end

  context 'with classic theme' do
    around { |example| with_theme(:classic) { example.run } }

    it_behaves_like 'button theme classes',
                    default: %w[
                      inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background
                      transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring
                      focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2
                      hover:bg-zinc-200 bg-zinc-50 text-zinc-950
                    ],
                    non_get: %w[
                      inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background
                      transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring
                      focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 py-1 px-2 rounded
                      hover:bg-zinc-200 bg-zinc-50 text-zinc-950 cursor-pointer
                    ],
                    link: %w[
                      inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background
                      transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring
                      focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2
                      hover:bg-zinc-200 bg-zinc-50 text-zinc-950 px-1 h-fit w-fit
                    ],
                    semantic: %w[
                      bg-violet-900/30 hover:bg-violet-900 text-violet-400
                    ],
                    inverse: %w[
                      bg-zinc-950 hover:bg-zinc-800 text-zinc-50 border border-zinc-800
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
