# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'

EXPECTED_FORM_CLASSES = {
  label: %w[tramway-form__label],
  text_input: %w[tramway-form__input],
  select_input: %w[tramway-form__select],
  file_button: %w[tramway-form__file-button],
  submit_button: %w[tramway-button tramway-button--submit],
  checkbox_input: %w[tramway-form__check-input]
}.freeze

RICH_TEXT_AREA_CLASSES = Tramway::Form::RichTextAreaComponent::RICH_TEXT_AREA_CLASSES

module DefaultRichTextAreaFormBuilder
  def rich_textarea(attribute, options = {}, &)
    template.content_tag('trix-editor', '', options.merge(input: attribute), &)
  end

  alias rich_text_area rich_textarea
end

Tramway::Views::FormBuilder.prepend(DefaultRichTextAreaFormBuilder)

describe Tramway::Form::Builder, type: :view do
  let(:resource) { build :user }
  let(:form_options) { {} }
  let(:builder) { described_class.new :user, resource, view, form_options }

  shared_examples 'form label and text input classes' do |expected_classes|
    it 'gets default value' do
      expect(output).to have_selector "label.#{class_selector(expected_classes.fetch(:label))}"
      expect(output).to have_selector "input.#{class_selector(expected_classes.fetch(:text_input))}"
    end
  end

  shared_examples 'form label and text input type classes' do |expected_classes|
    it 'renders input with tailwind classes' do
      expect(output).to have_selector "label.#{class_selector(expected_classes.fetch(:label))}"
      expect(output).to have_selector(
        "input[type=\"#{expected_classes.fetch(:type)}\"]." \
        "#{class_selector(expected_classes.fetch(:input))}"
      )
    end
  end

  shared_examples 'file field classes' do |expected_classes|
    it 'renders file label classes' do
      expect(output).to have_selector "label.#{class_selector(expected_classes)}"
    end
  end

  shared_examples 'submit button classes' do |expected_classes|
    it 'renders submit button classes' do
      expect(output).to have_selector "button.#{class_selector(expected_classes)}"
    end
  end

  shared_examples 'select field classes' do |expected_classes|
    it 'has the label' do
      expect(output).to have_selector "label.#{class_selector(expected_classes.fetch(:label))}"
    end

    it 'has the select' do
      expect(output).to have_selector "select.#{class_selector(expected_classes.fetch(:select))}"
      expect(output).to have_selector 'option[value="admin"]'
      expect(output).to have_selector 'option[value="user"]'
    end
  end

  shared_examples 'checkbox field classes' do |expected_classes|
    it 'renders checkbox with label and hidden input' do
      expect(output).to have_selector "label.#{class_selector(expected_classes.fetch(:label))}"
      expect(output).to have_selector 'input[type="checkbox"].hidden[data-ui--checkbox-target="input"]',
                                      visible: false
      expect(output).to have_selector '.tramway-form__check-row > button + label.tramway-form__check-label',
                                      text: 'Permissions'
      expect(output).to have_selector 'label[data-action="click->ui--checkbox#toggle"]'
    end

    it 'renders the checkbox label with the shared check label class and no inline styles' do
      label = Capybara.string(output).find('button + label')

      expect(label[:class].split).to include('tramway-form__label', 'tramway-form__check-label')
      expect(label[:style]).to be_nil
    end

    it 'renders shadcn-style checkbox button' do
      button = Capybara.string(output).find('button[role="checkbox"]')

      expect(button[:type]).to eq 'button'
      expect(button['aria-checked']).to eq 'false'
      expect(button['data-state']).to eq 'unchecked'
    end

    it 'renders the checkbox button without inline styles, sized and colored by the primitive class' do
      button = Capybara.string(output).find('button[role="checkbox"]')

      expect(button[:style]).to be_nil
      expect(button[:class].split).to include('tramway-form__check-input')
    end

    it 'renders checkbox button styling and indicator' do
      button = Capybara.string(output).find('button[role="checkbox"]')

      expect(button[:class].split).to include(*expected_classes.fetch(:checkbox_input))
      expect(output).to have_selector 'button span.tramway-form__check-indicator[hidden] svg.tramway-form__check-icon',
                                      visible: :all
    end
  end

  describe '#text_field' do
    context 'with default behaviour' do
      let(:output) { builder.text_field :email }

      context 'with the default classes' do
        it_behaves_like 'form label and text input classes', EXPECTED_FORM_CLASSES
      end
    end

    context 'with small size' do
      let(:form_options) { { size: :small } }
      let(:output) { builder.text_field :email }

      it 'applies small spacing' do
        expect(output).to have_selector 'input.tramway-form__input.tramway-form__input--sm'
      end
    end

    context 'with large size' do
      let(:form_options) { { size: :large } }
      let(:output) { builder.text_field :email }

      it 'applies large spacing' do
        expect(output).to have_selector 'input.tramway-form__input.tramway-form__input--lg'
      end
    end

    context 'when size option is passed directly to the field' do
      let(:output) { builder.text_field :email, size: :large }

      it 'keeps the form size classes' do
        expect(output).to have_selector 'input.tramway-form__input'
      end

      it 'does not render a size attribute' do
        expect(output).not_to have_selector 'input[size]'
      end
    end

    context 'with value from options' do
      let(:value) { 'leopold@purple-magic.com' }
      let(:output) { builder.text_field :email, value: }

      it 'gets value from options' do
        expect(output).to have_selector "input[value='#{value}']"
      end
    end

    context 'with value from object' do
      before { resource.email = email }

      let(:email) { 'leopold@purple-magic.com' }
      let(:output) { builder.text_field :email }

      it 'gets value from object' do
        expect(output).to have_selector "input[value='#{email}']"
      end
    end

    context 'with hint' do
      let(:output) { builder.text_field :email, hint: 'Use your work email address.' }

      it 'renders hint text below the input' do
        expect(output).to have_selector 'input + p.tramway-form__hint', text: 'Use your work email address.'
      end

      it 'does not forward hint as an input attribute' do
        expect(output).not_to have_selector 'input[hint]'
      end
    end
  end

  describe '#email_field' do
    let(:output) { builder.email_field :email }

    context 'with the default classes' do
      it_behaves_like 'form label and text input type classes',
                      label: EXPECTED_FORM_CLASSES[:label],
                      type: 'email',
                      input: EXPECTED_FORM_CLASSES[:text_input]
    end
  end

  describe '#number_field' do
    let(:output) { builder.number_field :id }

    context 'with the default classes' do
      it_behaves_like 'form label and text input type classes',
                      label: EXPECTED_FORM_CLASSES[:label],
                      type: 'number',
                      input: EXPECTED_FORM_CLASSES[:text_input]
    end
  end

  describe '#date_field' do
    let(:output) { builder.date_field :remember_created_at }

    context 'with the default classes' do
      it_behaves_like 'form label and text input type classes',
                      label: EXPECTED_FORM_CLASSES[:label],
                      type: 'date',
                      input: EXPECTED_FORM_CLASSES[:text_input]
    end

    context 'with value from object' do
      let(:value) { Date.new(2024, 1, 15) }

      before { resource.remember_created_at = value }

      it 'gets value from object' do
        expect(output).to have_selector "input[value='#{value}']"
      end
    end

    it 'opens the native calendar when clicking the input' do
      expect(output).to have_selector "input[onclick*='showPicker']"
    end

    context 'with custom click handler' do
      let(:output) { builder.date_field :remember_created_at, onclick: 'trackDateClick()' }

      it 'preserves custom click behavior before opening the calendar' do
        expect(output).to have_selector "input[onclick='trackDateClick(); " \
                                        "try { this.showPicker && this.showPicker() } catch (error) {}']"
      end
    end
  end

  describe '#datetime_field' do
    let(:output) { builder.datetime_field :remember_created_at }

    context 'with the default classes' do
      it_behaves_like 'form label and text input type classes',
                      label: EXPECTED_FORM_CLASSES[:label],
                      type: 'datetime-local',
                      input: EXPECTED_FORM_CLASSES[:text_input]
    end

    context 'with value from options' do
      let(:value) { '2024-01-15T13:30' }
      let(:output) { builder.datetime_field :remember_created_at, value: }

      it 'gets value from options' do
        expect(output).to have_selector "input[value='#{value}']"
      end
    end

    it 'opens the native calendar when clicking the input' do
      expect(output).to have_selector "input[onclick*='showPicker']"
    end
  end

  describe '#time_field' do
    let(:output) { builder.time_field :remember_created_at }

    context 'with the default classes' do
      it_behaves_like 'form label and text input type classes',
                      label: EXPECTED_FORM_CLASSES[:label],
                      type: 'time',
                      input: EXPECTED_FORM_CLASSES[:text_input]
    end

    context 'with value from options' do
      let(:value) { '13:30' }
      let(:output) { builder.time_field :remember_created_at, value: }

      it 'gets value from options' do
        expect(output).to have_selector "input[value='#{value}']"
      end
    end
  end

  describe '#password_field' do
    let(:output) do
      builder.password_field :password
    end

    context 'with the default classes' do
      it_behaves_like 'form label and text input classes', EXPECTED_FORM_CLASSES
    end
  end

  describe '#rich_text_area' do
    let(:output) { builder.rich_text_area :personal_info }
    let(:editor) { Capybara.string(output).find('trix-editor') }

    it 'calls the default rich text area helper' do
      expect(output).to have_selector 'trix-editor[input="personal_info"]'
    end

    it 'renders rich text input classes matching Tramway form colors' do
      expect(editor[:class].split).to include(*RICH_TEXT_AREA_CLASSES)
    end

    it 'renders a label for the attribute' do
      expect(output).to have_selector 'label', text: 'Personal info'
    end

    it 'renders label linked to the editor via for attribute' do
      expect(output).to have_selector 'label[for="user_personal_info"]'
    end

    context 'with custom classes and unsupported Tramway sizing option' do
      let(:output) { builder.rich_text_area :personal_info, class: 'custom-rich-text', size: :large }

      it 'preserves custom classes' do
        expect(output).to have_selector 'trix-editor.custom-rich-text'
      end

      it 'does not pass the Tramway sizing option to Action Text' do
        expect(output).not_to have_selector 'trix-editor[size]'
      end

      it 'preserves custom data attributes' do
        output = builder.rich_text_area :personal_info, data: { controller: 'mentions' }

        expect(output).to have_selector 'trix-editor[data-controller="mentions"]'
      end
    end

    context 'with label: false' do
      let(:output) { builder.rich_text_area :personal_info, label: false }

      it 'does not render a label' do
        expect(output).not_to have_selector 'label'
      end
    end

    context 'with hint' do
      let(:output) { builder.rich_text_area :personal_info, hint: 'Formatting is supported.' }

      it 'renders hint text below the editor' do
        expect(output).to have_selector 'trix-editor + p.tramway-form__hint',
                                        text: 'Formatting is supported.'
      end

      it 'does not forward hint as an editor attribute' do
        expect(output).not_to have_selector 'trix-editor[hint]'
      end
    end
  end

  describe '#rich_textarea' do
    let(:output) { builder.rich_textarea :personal_info }

    it 'is an alias for rich_text_area' do
      expect(output).to have_selector 'trix-editor[input="personal_info"]'
    end
  end

  describe '#tramway_field' do
    let(:output) { builder.tramway_field(:rich_text_area, :personal_info) }

    it 'renders rich text areas from field definitions' do
      expect(output).to have_selector 'trix-editor[input="personal_info"]'
    end
  end

  describe '#file_field' do
    let(:output) do
      builder.file_field :file
    end

    context 'with the default classes' do
      it_behaves_like 'file field classes', EXPECTED_FORM_CLASSES[:file_button]
    end

    context 'with small size' do
      let(:form_options) { { size: :small } }
      let(:output) { builder.file_field :file }

      it 'applies small spacing' do
        expect(output).to have_selector 'label.tramway-form__file-button--sm'
      end
    end
  end

  describe '#check_box' do
    let(:output) { builder.check_box :permissions }

    context 'with the default classes' do
      it_behaves_like 'checkbox field classes',
                      label: EXPECTED_FORM_CLASSES[:label],
                      checkbox_input: EXPECTED_FORM_CLASSES[:checkbox_input]
    end

    context 'with small size' do
      let(:form_options) { { size: :small } }

      it 'aligns a compact checkbox and label' do
        expect(output).to have_selector 'button.tramway-form__check-input.tramway-form__check-input--sm'
        expect(output).to have_selector 'button + label.tramway-form__check-label'
      end
    end

    context 'with large size' do
      let(:form_options) { { size: :large } }

      it 'aligns a large checkbox and label' do
        expect(output).to have_selector 'button.tramway-form__check-input.tramway-form__check-input--lg'
        expect(output).to have_selector 'button + label.tramway-form__check-label'
      end
    end

    context 'with hint' do
      let(:output) { builder.check_box :permissions, hint: 'Allow access to admin actions.' }

      it 'renders hint text below the checkbox row' do
        expect(output).to have_selector '.tramway-form__check-row + p.tramway-form__hint',
                                        text: 'Allow access to admin actions.'
      end

      it 'does not forward hint as an input attribute' do
        expect(output).not_to have_selector 'input[hint]', visible: false
      end
    end
  end

  describe '#checkbox' do
    let(:output) { builder.checkbox :permissions }

    context 'with the default classes' do
      it_behaves_like 'checkbox field classes',
                      label: EXPECTED_FORM_CLASSES[:label],
                      checkbox_input: EXPECTED_FORM_CLASSES[:checkbox_input]
    end
  end

  describe '#submit' do
    let(:output) do
      builder.submit 'Create'
    end

    context 'with the default classes' do
      it_behaves_like 'submit button classes', EXPECTED_FORM_CLASSES[:submit_button]
    end

    context 'with attributes checks' do
      let(:output) { builder.submit 'Create' }

      it 'renders a submit button' do
        expect(output).to have_selector 'button[name="commit"][type="submit"]'
      end
    end

    context 'with large size' do
      let(:form_options) { { size: :large } }
      let(:output) { builder.submit 'Create' }

      it 'renders the configured button size' do
        expect(output).to have_selector 'button.tramway-button.tramway-button--lg'
      end
    end
  end

  describe '#select' do
    context 'with default behaviour' do
      let(:output) { builder.select :role, %i[admin user] }

      context 'with the default classes' do
        it_behaves_like 'select field classes',
                        label: EXPECTED_FORM_CLASSES[:label],
                        select: EXPECTED_FORM_CLASSES[:select_input]
      end
    end

    context 'with small size' do
      let(:form_options) { { size: :small } }
      let(:output) { builder.select :role, %i[admin user] }

      it 'applies small spacing' do
        expect(output).to have_selector 'select.tramway-form__select.tramway-form__select--sm'
      end
    end

    context 'with value from options' do
      let(:selected) { :admin }
      let(:output) { builder.select :role, %i[admin user], selected: }

      it 'gets value from options' do
        expect(output).to have_selector 'option[value="admin"][selected]'
      end
    end

    context 'with value from object' do
      before { resource.role = :admin }

      let(:output) { builder.select :role, %i[admin user] }

      it 'gets value from object' do
        expect(output).to have_selector 'option[value="admin"][selected]'
      end
    end

    context 'with hint' do
      let(:output) { builder.select :role, %i[admin user], hint: 'Choose the account role.' }

      it 'renders hint text below the select' do
        expect(output).to have_selector 'select + p.tramway-form__hint', text: 'Choose the account role.'
      end

      it 'does not forward hint as a select attribute' do
        expect(output).not_to have_selector 'select[hint]'
      end
    end
  end
end
