# frozen_string_literal: true

require 'support/view_helpers'

describe Tailwinds::Form::Builder, type: :view do
  let(:resource)  { build :user }
  let(:builder) { Tailwinds::Form::Builder.new :user, resource, view, {} }

  describe '#text_field' do
    let(:output) do
      builder.text_field :email
    end

    it do
      expect(output).to have_selector 'label.block.text-gray-700.text-sm.font-bold.mb-2'
      expect(output).to have_selector 'input.w-full.px-3.py-2.border.border-gray-300.rounded'
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
    let(:output) do
      builder.select :role, %i[admin user]
    end

    it do
      expect(output).to have_selector 'label.block.text-gray-700.text-sm.font-bold.mb-2'
      expect(output).to have_selector 'select.bg-white.border.border-gray-300.text-gray-700.py-2.px-2.rounded-lg'
      expect(output).to have_selector 'option[value="admin"]'
      expect(output).to have_selector 'option[value="user"]'
    end
  end
end
