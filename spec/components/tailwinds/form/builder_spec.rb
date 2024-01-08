# frozen_string_literal: true

require 'support/view_helpers'

describe Tailwinds::Form::Builder, type: :view do
  let(:resource)  { build :user }
  let(:builder) { Tailwinds::Form::Builder.new :user, resource, view, {} }

  describe '#text_field' do
    context 'default' do
      let(:output) { builder.text_field :email }

      it 'gets default value' do
        expect(output).to have_selector 'label.block.text-gray-700.text-sm.font-bold.mb-2'
        expect(output).to have_selector 'input.w-full.px-3.py-2.border.border-gray-300.rounded'
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
      expect(output).to have_selector 'input.w-full.px-3.py-2.border.border-gray-300.rounded'
    end
  end

  describe '#file_field' do
    let(:output) do
      builder.file_field :file
    end

    it do
      expect(output).to have_selector 'label.inline-block.bg-blue-500.text-white.font-bold.py-2.px-4.rounded'
    end
  end

  describe '#submit' do
    let(:output) do
      builder.submit 'Create'
    end

    it do
      within 'div.flex.items-center.justify-between' do
        expect(output).to have_selector('button.bg-red-500.text-white')
      end
    end
  end

  describe '#select' do
    context 'default' do
      let(:output) { builder.select :role, %i[admin user] }

      it 'behaves as usual' do
        expect(output).to have_selector 'label.block.text-gray-700.text-sm.font-bold.mb-2'
        expect(output).to have_selector 'select.bg-white.border.border-gray-300.text-gray-700.py-2.px-2.rounded-lg'
        expect(output).to have_selector 'option[value="admin"]'
        expect(output).to have_selector 'option[value="user"]'
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
