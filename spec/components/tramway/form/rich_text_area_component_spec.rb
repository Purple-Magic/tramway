# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'

# Tramway::Form::RichTextAreaComponent wraps a Trix rich text editor with
# Tramway's dark-theme Tailwind styling and an optional label.
#
# Usage in a form builder:
#   = f.rich_text_area :body
#   = f.rich_text_area :body, label: 'Post body', class: 'extra-class'
#   = f.rich_text_area :body, label: false  # no label
#
# Requires the Trix stylesheet and JavaScript in your application layout:
#   = stylesheet_link_tag "trix", "data-turbo-track": "reload"
#   = javascript_include_tag "trix", "data-turbo-track": "reload", defer: true

module DefaultRichTextAreaFormBuilderForComponent
  def rich_textarea(attribute, options = {}, &)
    template.content_tag('trix-editor', '', options.merge(input: attribute), &)
  end

  alias rich_text_area rich_textarea
end

Tramway::Views::FormBuilder.prepend(DefaultRichTextAreaFormBuilderForComponent)

describe Tramway::Form::RichTextAreaComponent, type: :component do
  subject(:component) do
    described_class.new(
      input: input_proc,
      attribute: :body,
      label: 'Body',
      for: 'post_body',
      options: {},
      size: :medium
    )
  end

  let(:input_proc) do
    proc { |attr, **opts| ActionController::Base.helpers.content_tag('trix-editor', '', input: attr, class: opts[:class]) }
  end

  it 'renders a trix-editor element' do
    render_inline(component)

    expect(page).to have_css('trix-editor')
  end

  it 'renders a label for the field' do
    render_inline(component)

    expect(page).to have_css('label', text: 'Body')
  end

  it 'renders the label linked to the editor' do
    render_inline(component)

    expect(page).to have_css('label[for="post_body"]')
  end

  it 'applies Tramway dark-theme classes to the editor' do
    render_inline(component)

    editor = page.find('trix-editor')
    expected_classes = Tramway::Form::RichTextAreaComponent::RICH_TEXT_AREA_CLASSES

    expect(editor[:class].split).to include(*expected_classes)
  end

  context 'when label is false' do
    subject(:component) do
      described_class.new(
        input: input_proc,
        attribute: :body,
        label: false,
        for: 'post_body',
        options: {},
        size: :medium
      )
    end

    it 'does not render a label element' do
      render_inline(component)

      expect(page).to have_no_css('label')
    end
  end

  context 'when custom class is provided' do
    subject(:component) do
      described_class.new(
        input: input_proc,
        attribute: :body,
        label: 'Body',
        for: 'post_body',
        options: { class: 'my-editor' },
        size: :medium
      )
    end

    it 'merges the custom class with Tramway default classes' do
      render_inline(component)

      editor = page.find('trix-editor')

      expect(editor[:class]).to include('my-editor')
      expect(editor[:class]).to include('trix-content')
    end
  end
end
