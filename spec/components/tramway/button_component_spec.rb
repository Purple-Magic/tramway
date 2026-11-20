# frozen_string_literal: true

require 'rails_helper'

describe Tramway::ButtonComponent, type: :component do
  shared_examples 'button classes' do |expected_classes|
    context 'when text is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'View projects') }

      it 'renders button_to with defaults' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(expected_classes.fetch(:default))}[href='/projects']",
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
          "form[action='/projects/1'] button.#{class_selector(expected_classes.fetch(:non_get))}" \
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
          "a[href='/projects'].#{class_selector(expected_classes.fetch(:link))}",
          text: 'View projects'
        )
      end
    end

    context 'when path is a hash placeholder' do
      let(:component) { described_class.new(path: '#', text: 'View projects') }

      it 'renders a link_to element' do
        render_inline(component)

        expect(page).to have_css(
          "a[href='#'].#{class_selector(expected_classes.fetch(:link))}",
          text: 'View projects'
        )
      end
    end

    context 'when a semantic type is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'Celebrate', type: :love) }

      it 'renders button with mapped color' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(expected_classes.fetch(:semantic))}[href='/projects']",
          text: 'Celebrate'
        )
      end
    end

    context 'when inverse type is provided' do
      let(:component) { described_class.new(path: '/projects', text: 'Invert', type: :inverse) }

      it 'renders button with inverse default colors and matching border' do
        render_inline(component)

        expect(page).to have_css(
          "a.#{class_selector(expected_classes.fetch(:inverse))}[href='/projects']",
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
          "a[href='/projects'][disabled='disabled'].#{class_selector(expected_classes.fetch(:disabled))}",
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
          "a[href='#{path}'].#{class_selector(expected_classes.fetch(:link))}",
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

        expect(page).to have_css('div.tramway-tooltip')
        expect(page).to have_css('div.tramway-tooltip__trigger--hover')
        expect(page).to have_css(
          "a.#{class_selector(expected_classes.fetch(:default))}[href='/projects']",
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

  context 'with the default classes' do
    it_behaves_like 'button classes',
                    default: %w[tramway-button tramway-button--secondary],
                    non_get: %w[tramway-button tramway-button--sm tramway-button--tint tramway-tint--red],
                    link: %w[tramway-button tramway-button--secondary],
                    semantic: %w[tramway-button tramway-button--primary],
                    inverse: %w[tramway-button tramway-button--ghost],
                    disabled: %w[tramway-button tramway-button--primary]
  end

  describe 'variants' do
    {
      default: :secondary, life: :secondary, secondary: :secondary, primary: :primary, hope: :primary,
      success: :success, will: :success, submit: :submit, warning: :warning, greed: :warning,
      danger: :danger, rage: :danger, inverse: :ghost, love: :primary, compassion: :secondary, fear: :warning
    }.each do |type, variant|
      it "renders the #{variant} variant for type #{type}" do
        render_inline(described_class.new(path: '/projects', text: 'Go', type:))

        expect(page).to have_css("a.tramway-button.tramway-button--#{variant}")
      end
    end

    it 'falls back to a tinted variant for an explicit Tailwind color' do
      render_inline(described_class.new(path: '/projects', text: 'Go', color: :teal))

      expect(page).to have_css('a.tramway-button.tramway-button--tint.tramway-tint--teal')
    end

    it 'uses the variant of an explicit color that is a Tramway type' do
      render_inline(described_class.new(path: '/projects', text: 'Go', color: :danger))

      expect(page).to have_css('a.tramway-button.tramway-button--danger')
    end

    it 'renders the large size modifier' do
      render_inline(described_class.new(path: '/projects', text: 'Go', size: :large))

      expect(page).to have_css('a.tramway-button.tramway-button--lg')
    end
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
