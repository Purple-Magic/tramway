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
          type: :danger,
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

    context 'when an outline type is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'Details', type: :outline) }

      it 'renders button with variant classes' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(theme_classes.fetch(:outline))}[href='/projects']",
          text: 'Details'
        )
      end
    end

    context 'when a ghost type is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'Preview', type: :ghost) }

      it 'renders button with variant classes' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(theme_classes.fetch(:ghost))}[href='/projects']",
          text: 'Preview'
        )
      end
    end

    context 'when a destructive alias type is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'Archive', type: :error) }

      it 'renders button with destructive classes' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(theme_classes.fetch(:destructive))}[href='/projects']",
          text: 'Archive'
        )
      end
    end

    context 'when disabled: true is provided in options' do
      let(:component) do
        described_class.new(path: '/projects', text: 'Celebrate', type: :default, options: { disabled: true })
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
                      inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background
                      transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring
                      focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2
                      bg-zinc-50 text-zinc-950 hover:bg-zinc-200 w-fit cursor-pointer
                    ],
                    non_get: %w[
                      inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background
                      transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring
                      focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-9 px-3 py-1.5
                      extra-class bg-red-600 text-red-600 hover:bg-red-600/90 cursor-pointer
                    ],
                    link: %w[
                      inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background
                      transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring
                      focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 h-10 px-4 py-2
                      bg-zinc-50 text-zinc-950 hover:bg-zinc-200 w-fit cursor-pointer
                    ],
                    outline: %w[border border-input bg-background hover:bg-accent hover:text-accent],
                    ghost: %w[hover:bg-accent hover:text-accent],
                    destructive: %w[bg-red-600 text-red-600 hover:bg-red-600/90],
                    disabled: %w[pointer-events-none opacity-50]
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
          type: :alert,
          size: :small
        ) do
          'Edit'
        end
      )

      expect(page).to have_css('a')
    end
  end
end
