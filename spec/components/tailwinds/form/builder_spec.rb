# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'

CLASSIC_FORM_CLASSES = {
  label: %w[block text-sm font-semibold mb-2 text-white],
  text_input: %w[
    w-full rounded-xl border border-gray-200 bg-gray-100 text-gray-700 shadow-inner focus:outline-none
    focus:ring-2 focus:ring-gray-300 placeholder-gray-400
  ],
  select_input: %w[
    w-full rounded-xl border border-gray-200 bg-gray-100 text-gray-700 shadow-inner focus:outline-none
    focus:ring-2 focus:ring-gray-300 disabled:cursor-not-allowed disabled:bg-gray-200 disabled:text-gray-400
  ],
  file_button: %w[
    inline-block text-blue-800 font-semibold rounded-xl cursor-pointer mt-4 bg-blue-100 hover:bg-blue-200
    shadow-md
  ],
  submit_button: %w[
    font-semibold rounded-xl focus:outline-none focus:ring-2 focus:ring-red-200 cursor-pointer bg-green-100
    hover:bg-green-200 shadow-md
  ]
}.freeze

describe Tailwinds::Form::Builder, type: :view do
  let(:resource) { build :user }
  let(:form_options) { {} }
  let(:builder) { described_class.new :user, resource, view, form_options }

  shared_examples 'form label and text input classes' do |theme_classes|
    it 'gets default value' do
      expect(output).to have_selector "label.#{class_selector(theme_classes.fetch(:label))}"
      expect(output).to have_selector "input.text-base.px-3.py-2.#{class_selector(theme_classes.fetch(:text_input))}"
    end
  end

  shared_examples 'form label and text input type classes' do |theme_classes|
    it 'renders input with tailwind classes' do
      expect(output).to have_selector "label.#{class_selector(theme_classes.fetch(:label))}"
      expect(output).to have_selector(
        "input[type=\"#{theme_classes.fetch(:type)}\"].text-base.px-3.py-2." \
        "#{class_selector(theme_classes.fetch(:input))}"
      )
    end
  end

  shared_examples 'file field classes' do |theme_classes|
    it 'renders file label classes' do
      expect(output).to have_selector "label.inline-block.text-base.px-4.py-2.#{class_selector(theme_classes)}"
    end
  end

  shared_examples 'submit button classes' do |theme_classes|
    it 'renders submit button classes' do
      within 'div.flex.items-center.justify-between' do
        expect(output).to have_selector "button.text-base.#{class_selector(theme_classes)}"
      end
    end
  end

  shared_examples 'select field classes' do |theme_classes|
    it 'has the label' do
      expect(output).to have_selector "label.#{class_selector(theme_classes.fetch(:label))}"
    end

    it 'has the select' do
      expect(output).to have_selector "select.text-base.#{class_selector(theme_classes.fetch(:select))}"
      expect(output).to have_selector 'option[value="admin"]'
      expect(output).to have_selector 'option[value="user"]'
    end
  end

  describe '#text_field' do
    context 'with default behaviour' do
      let(:output) { builder.text_field :email }

      context 'with classic theme' do
        around { |example| with_theme(:classic) { example.run } }

        it_behaves_like 'form label and text input classes', CLASSIC_FORM_CLASSES
      end
    end

    context 'with small size' do
      let(:form_options) { { size: :small } }
      let(:output) { builder.text_field :email }

      it 'applies small spacing' do
        expect(output).to have_selector 'input.text-sm.px-2.py-1'
      end
    end

    context 'with large size' do
      let(:form_options) { { size: :large } }
      let(:output) { builder.text_field :email }

      it 'applies large spacing' do
        expect(output).to have_selector 'input.text-xl.px-4.py-3'
      end
    end

    context 'when size option is passed directly to the field' do
      let(:output) { builder.text_field :email, size: :large }

      it 'keeps the form size classes' do
        expect(output).to have_selector 'input.text-base.px-3.py-2'
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
  end

  describe '#email_field' do
    let(:output) { builder.email_field :email }

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'form label and text input type classes',
                      label: CLASSIC_FORM_CLASSES[:label],
                      type: 'email',
                      input: CLASSIC_FORM_CLASSES[:text_input]
    end
  end

  describe '#number_field' do
    let(:output) { builder.number_field :id }

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'form label and text input type classes',
                      label: CLASSIC_FORM_CLASSES[:label],
                      type: 'number',
                      input: CLASSIC_FORM_CLASSES[:text_input]
    end
  end

  describe '#date_field' do
    let(:output) { builder.date_field :remember_created_at }

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'form label and text input type classes',
                      label: CLASSIC_FORM_CLASSES[:label],
                      type: 'date',
                      input: CLASSIC_FORM_CLASSES[:text_input]
    end

    context 'with value from object' do
      let(:value) { Date.new(2024, 1, 15) }

      before { resource.remember_created_at = value }

      it 'gets value from object' do
        expect(output).to have_selector "input[value='#{value}']"
      end
    end
  end

  describe '#password_field' do
    let(:output) do
      builder.password_field :password
    end

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'form label and text input classes', CLASSIC_FORM_CLASSES
    end
  end

  describe '#file_field' do
    let(:output) do
      builder.file_field :file
    end

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'file field classes', CLASSIC_FORM_CLASSES[:file_button]
    end

    context 'with small size' do
      let(:form_options) { { size: :small } }
      let(:output) { builder.file_field :file }

      it 'applies small spacing' do
        expect(output).to have_selector 'label.text-sm.px-3.py-1'
      end
    end
  end

  describe '#submit' do
    let(:output) do
      builder.submit 'Create'
    end

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'submit button classes', CLASSIC_FORM_CLASSES[:submit_button]
    end

    context 'with large size' do
      let(:form_options) { { size: :large } }
      let(:output) { builder.submit 'Create' }

      it 'renders larger button' do
        expect(output).to have_selector 'button.text-xl.px-5.py-3'
      end
    end
  end

  describe '#select' do
    context 'with default behaviour' do
      let(:output) { builder.select :role, %i[admin user] }

      context 'with classic theme' do
        around { |example| with_theme(:classic) { example.run } }

        it_behaves_like 'select field classes',
                        label: CLASSIC_FORM_CLASSES[:label],
                        select: CLASSIC_FORM_CLASSES[:select_input]
      end
    end

    context 'with small size' do
      let(:form_options) { { size: :small } }
      let(:output) { builder.select :role, %i[admin user] }

      it 'applies small spacing' do
        expect(output).to have_selector 'select.text-sm.px-2.py-1'
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
  end
end
