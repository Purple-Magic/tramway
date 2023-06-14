# frozen_string_literal: true

# spec/tramway/helpers/tailwind_helpers_spec.rb

require 'rails_helper'
require 'support/view_helpers'

describe Tramway::Helpers::TailwindHelpers, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend Tramway::Helpers::TailwindHelpers
  end

  let(:path) { '/test' }
  let(:text) { 'Button Text' }

  describe '#tailwind_clickable' do
    context 'with link rendering checks' do
      let(:options) { { href: path } }

      context 'when text is provided' do
        it 'renders the Navbar::ButtonComponent with the provided text' do
          fragment = view.tailwind_clickable(text, **options)

          expect(fragment).to have_content 'Button Text'
          expect(fragment).to have_css "a[href='#{path}']"
        end
      end

      context 'when a block is given' do
        it 'renders the Navbar::ButtonComponent with the provided options and block' do
          block = proc { text }

          fragment = view.tailwind_clickable(**options, &block)

          expect(fragment).to have_content 'Button Text'
          expect(fragment).to have_css "a[href='#{path}']"
        end
      end
    end

    context 'with button rendering checks' do
      let(:options) { { action: path, method: %i[get post patch put delete].sample } }

      context 'when text is provided' do
        it 'renders the Navbar::ButtonComponent with the provided text' do
          fragment = view.tailwind_clickable(text, **options)

          expect(fragment).to have_content 'Button Text'
          expect(fragment).to have_css "form[action='#{path}']"
        end
      end

      context 'when a block is given' do
        it 'renders the Navbar::ButtonComponent with the provided options and block' do
          block = proc { text }

          fragment = view.tailwind_clickable(**options, &block)

          expect(fragment).to have_content 'Button Text'
          expect(fragment).to have_css "form[action='#{path}']"
        end
      end
    end
  end

  context 'with aliases checks' do
    let(:helper) { Class.new { include Tramway::Helpers::TailwindHelpers }.new }

    describe '#tailwind_button_to' do
      it 'is an alias for tailwind_clickable' do
        expect(helper.method(:tailwind_button_to)).to eq(helper.method(:tailwind_clickable))
      end
    end

    describe '#tailwind_link_to' do
      it 'is an alias for tailwind_clickable' do
        expect(helper.method(:tailwind_link_to)).to eq(helper.method(:tailwind_clickable))
      end
    end
  end
end
