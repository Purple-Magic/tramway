# frozen_string_literal: true

require 'rails_helper'

describe Tailwinds::Form::Builder, type: :view do
  describe '#text_field' do
    let(:resource)  { build :user }
    let(:builder) { Tailwinds::Form::Builder.new :user, resource, view, {} }
    let(:output) do
      builder.text_field :email
    end

    it do
      expect(output).to have_selector 'label.block.text-gray-700.text-sm.font-bold.mb-2'
      expect(output).to have_selector 'input.w-full.px-3.py-2.border.border-gray-300.rounded'
    end
  end
end
