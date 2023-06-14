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
  let(:block) { proc { text } }

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

    context 'with raising errors' do
      it 'raises error in case there are text and block in the same time' do
        expect { view.tailwind_clickable(text, &block) }.to(
          raise_error 'You can not provide argument and code block in the same time'
        )
      end

      it 'raises error in case there is only text without options' do
        expect { view.tailwind_clickable(text) }.to(
          raise_error 'You should provide `action` or `href` option'
        )
      end

      it 'raises error in case there is only block without options' do
        expect { view.tailwind_clickable(&block) }.to(
          raise_error 'You should provide `action` or `href` option'
        )
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
