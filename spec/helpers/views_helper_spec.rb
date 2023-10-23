# frozen_string_literal: true

require 'support/view_helpers'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_form_for' do
    it 'calls form_for with the correct builder' do
      object = double('Model')
      expect(view).to receive(:form_for).with(object, anything, hash_including(builder: Tailwinds::Form::Builder))

      view.tramway_form_for(object)
    end

    it 'forwards arguments and options to form_for' do
      object = double('Model')
      args = %i[arg1 arg2]
      options = { key: 'value' }

      expect(view).to receive(:form_for).with(object, *args, hash_including(options))

      view.tramway_form_for(object, *args, options)
    end
  end

  describe '#tailwind_submit_button' do
    it 'renders a Tailwinds::Form::SubmitButtonComponent' do
      action = 'Submit'
      options = { class: 'custom-class' }

      expect(view).to receive(:render).with(an_instance_of(Tailwinds::Form::SubmitButtonComponent))

      view.tailwind_submit_button(action, options)
    end

    it 'forwards action and options to the SubmitButtonComponent' do
      action = 'Submit'
      options = { class: 'custom-class', data: { key: 'value' } }

      expect(view).to receive(:render).with(an_instance_of(Tailwinds::Form::SubmitButtonComponent).and(
                                              have_attributes(action:, options:)
                                            ))

      view.tailwind_submit_button(action, options)
    end
  end
end
