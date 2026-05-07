# frozen_string_literal: true

require 'rails_helper'
require 'support/view_helpers'

CLASSIC_FORM_CLASSES = {
  label: %w[mb-2 block text-sm font-medium leading-none text-zinc-300],
  text_input: %w[
    w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm placeholder:text-zinc-500
    focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-zinc-300 disabled:cursor-not-allowed
    disabled:opacity-50
  ],
  select_input: %w[
    w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm focus-visible:outline-none
    focus-visible:ring-1 focus-visible:ring-zinc-300 disabled:cursor-not-allowed disabled:opacity-50
  ],
  file_button: %w[
    inline-flex items-center justify-center rounded-md bg-zinc-50 text-sm font-medium text-zinc-950 shadow-sm
    transition-colors hover:bg-zinc-200 cursor-pointer mt-4
  ],
  submit_button: %w[
    font-medium rounded-md cursor-pointer
  ],
  checkbox_input: %w[
    absolute size-px overflow-hidden whitespace-nowrap border-0 p-0 -m-px [clip-path:inset(50%)]
  ],
  checkbox_button: %w[
    peer h-4 w-4 shrink-0 rounded-sm border border-zinc-800 bg-zinc-800/30 ring-offset-zinc-950
    focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-300 focus-visible:ring-offset-2
    disabled:cursor-not-allowed disabled:opacity-50 data-[state=checked]:border-zinc-50
    data-[state=checked]:bg-zinc-50 data-[state=checked]:text-zinc-950
  ],
  checkbox_label: %w[
    text-sm font-medium leading-normal text-zinc-300 peer-disabled:cursor-not-allowed peer-disabled:opacity-70
    cursor-pointer text-base
  ]
}.freeze

describe Tramway::Form::Builder, type: :view do
  let(:resource) { build :user }
  let(:form_options) { {} }
  let(:builder) { described_class.new :user, resource, view, form_options }

  shared_examples 'form label and text input classes' do |theme_classes|
    it 'gets default value' do
      expect(output).to have_selector "label.#{class_selector(theme_classes.fetch(:label))}"
      expect(output).to have_selector "input.h-9.text-sm.px-3.py-1.#{class_selector(theme_classes.fetch(:text_input))}"
    end
  end

  shared_examples 'form label and text input type classes' do |theme_classes|
    it 'renders input with tailwind classes' do
      expect(output).to have_selector "label.#{class_selector(theme_classes.fetch(:label))}"
      expect(output).to have_selector(
        "input[type=\"#{theme_classes.fetch(:type)}\"].h-9.text-sm.px-3.py-1." \
        "#{class_selector(theme_classes.fetch(:input))}"
      )
    end
  end

  shared_examples 'file field classes' do |theme_classes|
    it 'renders file label classes' do
      expect(output).to have_selector "label.inline-flex.h-9.text-sm.px-4.py-2.#{class_selector(theme_classes)}"
    end
  end

  shared_examples 'submit button classes' do |theme_classes|
    it 'renders submit button classes' do
      expect(output).to have_selector "button.bg-zinc-50.#{class_selector(theme_classes)}"
    end
  end

  shared_examples 'select field classes' do |theme_classes|
    it 'has the label' do
      expect(output).to have_selector "label.#{class_selector(theme_classes.fetch(:label))}"
    end

    it 'has the select' do
      expect(output).to have_selector "select.h-9.text-sm.#{class_selector(theme_classes.fetch(:select))}"
      expect(output).to have_selector 'option[value="admin"]'
      expect(output).to have_selector 'option[value="user"]'
    end
  end

  shared_examples 'checkbox field classes' do |theme_classes|
    it 'renders checkbox with label and classes' do
      expect(output).to have_selector "label.#{class_selector(theme_classes.fetch(:label))}"
      expect(output).to have_selector(
        "input[type=\"checkbox\"].#{class_selector(theme_classes.fetch(:checkbox_input))}",
        visible: :all
      )
      expect(output).to have_selector(
        "button[type=\"button\"][role=\"checkbox\"].#{class_selector(theme_classes.fetch(:checkbox_button))}"
      )
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
        expect(output).to have_selector 'input.h-10.text-base.px-4.py-2'
      end
    end

    context 'when size option is passed directly to the field' do
      let(:output) { builder.text_field :email, size: :large }

      it 'keeps the form size classes' do
        expect(output).to have_selector 'input.h-9.text-sm.px-3.py-1'
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

  describe '#datetime_field' do
    let(:output) { builder.datetime_field :remember_created_at }

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'form label and text input type classes',
                      label: CLASSIC_FORM_CLASSES[:label],
                      type: 'datetime-local',
                      input: CLASSIC_FORM_CLASSES[:text_input]
    end

    context 'with value from options' do
      let(:value) { '2024-01-15T13:30' }
      let(:output) { builder.datetime_field :remember_created_at, value: }

      it 'gets value from options' do
        expect(output).to have_selector "input[value='#{value}']"
      end
    end
  end

  describe '#time_field' do
    let(:output) { builder.time_field :remember_created_at }

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'form label and text input type classes',
                      label: CLASSIC_FORM_CLASSES[:label],
                      type: 'time',
                      input: CLASSIC_FORM_CLASSES[:text_input]
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

  describe '#check_box' do
    let(:output) { builder.check_box :permissions }

    context 'with classic theme' do
      around { |example| with_theme(:classic) { example.run } }

      it_behaves_like 'checkbox field classes',
                      label: CLASSIC_FORM_CLASSES[:checkbox_label],
                      checkbox_input: CLASSIC_FORM_CLASSES[:checkbox_input],
                      checkbox_button: CLASSIC_FORM_CLASSES[:checkbox_button]
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

    context 'with attributes checks' do
      let(:output) { builder.submit 'Create' }

      it 'renders a submit button' do
        expect(output).to have_selector 'button[name="commit"][type="submit"]'
      end
    end

    context 'with large size' do
      let(:form_options) { { size: :large } }
      let(:output) { builder.submit 'Create' }

      it 'renders larger button' do
        expect(output).to have_selector 'button.h-11.text-base.px-8'
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
