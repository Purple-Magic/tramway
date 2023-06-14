# spec/tramway/helpers/tailwind_helpers_spec.rb

require 'rails_helper'

describe Tramway::Helpers::TailwindHelpers, type: :helper do
  let(:helper) { Class.new { include Tramway::Helpers::TailwindHelpers }.new }
  
  describe '#tailwind_clickable' do
    context 'when text is provided' do
      it 'renders the Navbar::ButtonComponent with the provided text' do
        text = 'Button Text'
        options = { class: 'button' }
        component_double = instance_double('Tailwinds::Navbar::ButtonComponent')

        expect(Tailwinds::Navbar::ButtonComponent)
          .to receive(:new)
          .with(options)
          .and_return(component_double)

        helper.tailwind_clickable(text, options)
      end
    end

    context 'when a block is given' do
      it 'renders the Navbar::ButtonComponent with the provided options and block' do
        options = { class: 'button' }
        component_double = instance_double('Tailwinds::Navbar::ButtonComponent')
        block = proc { 'Button Block' }

        expect(Tailwinds::Navbar::ButtonComponent)
          .to receive(:new)
          .with(options)
          .and_return(component_double)

        expect(helper).to receive(:render)
          .with(component_double)
          .and_yield

        expect(helper).to receive(:instance_exec)
          .with(&block)

        helper.tailwind_clickable(options, &block)
      end
    end
  end

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

