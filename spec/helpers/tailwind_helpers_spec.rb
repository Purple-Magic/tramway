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
  let(:options) { { method: :delete, confirm: 'Yes?' } }

  describe '#tailwind_link_to' do
    context 'with link rendering checks' do
      context 'when text is provided' do
        it 'renders the Navbar::ButtonComponent with the provided text' do
          fragment = view.tailwind_link_to(text, path, **options)

          expect(fragment).to have_content 'Button Text'
          expect(fragment).to have_css "a[href='#{path}']"
          expect(fragment).to have_css "a[data-turbo-method='#{options[:method]}']"
          expect(fragment).to have_css "a[data-turbo-confirm='#{options[:confirm]}']"
        end
      end

      context 'when a block is given' do
        it 'renders the Navbar::ButtonComponent with the provided options and block' do
          fragment = view.tailwind_link_to(path, **options, &block)

          expect(fragment).to have_content 'Button Text'
          expect(fragment).to have_css "a[href='#{path}']"
          expect(fragment).to have_css "a[data-turbo-method='#{options[:method]}']"
          expect(fragment).to have_css "a[data-turbo-confirm='#{options[:confirm]}']"
        end
      end
    end

    context 'with raising errors' do
      it 'raises error in case there are text and block in the same time' do
        expect { view.tailwind_link_to(text, path, &block) }.to(
          raise_error 'You can not provide argument and code block in the same time'
        )
      end
    end
  end
end
