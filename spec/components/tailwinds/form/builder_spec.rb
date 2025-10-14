# frozen_string_literal: true

require 'support/view_helpers'

describe Tailwinds::Form::Builder, type: :view do
  let(:resource)  { build :user }
  let(:form_options) { {} }
  let(:builder) { described_class.new :user, resource, view, form_options }

  describe '#text_field' do
    context 'with default behaviour' do
      let(:output) { builder.text_field :email }

      it 'gets default value' do
        expect(output).to have_selector 'label.block.text-gray-700.text-sm.font-bold.mb-2'
        expect(output).to have_selector 'input.text-base.px-3.py-2.w-full.border.border-gray-300.rounded'
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
        expect(output).to have_selector 'input.text-lg.px-4.py-3'
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

  describe '#password_field' do
    let(:output) do
      builder.password_field :password
    end

    it do
      expect(output).to have_selector 'label.block.text-gray-700.text-sm.font-bold.mb-2'
      expect(output).to have_selector 'input.text-base.px-3.py-2.w-full.border.border-gray-300.rounded'
    end
  end

  describe '#file_field' do
    let(:output) do
      builder.file_field :file
    end

    it do
      expect(output).to have_selector 'label.inline-block.text-base.px-4.py-2.bg-blue-500.text-white.font-bold.rounded'
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

    it do
      within 'div.flex.items-center.justify-between' do
        expect(output).to have_selector('button.text-base.bg-red-500.text-white')
      end
    end

    context 'with large size' do
      let(:form_options) { { size: :large } }
      let(:output) { builder.submit 'Create' }

      it 'renders larger button' do
        expect(output).to have_selector 'button.text-lg.px-5.py-3'
      end
    end
  end

  describe '#select' do
    context 'with default behaviour' do
      let(:output) { builder.select :role, %i[admin user] }

      it 'has the label' do
        expect(output).to have_selector 'label.block.text-gray-700.text-sm.font-bold.mb-2'
      end

      it 'has the select' do
        expect(output).to have_selector 'select.text-base.bg-white.border.border-gray-300.text-gray-700'
        expect(output).to have_selector 'option[value="admin"]'
        expect(output).to have_selector 'option[value="user"]'
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
