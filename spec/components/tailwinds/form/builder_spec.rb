# frozen_string_literal: true

require 'rails_helper'

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
      expect(output).to have_selector(
        "input[onchange=\"document.getElementById(\'file_label\').textContent = this.files[0].name\"]"
      )
    end
  end
end
