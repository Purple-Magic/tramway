# frozen_string_literal: true

require 'support/view_helpers'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_form_for' do
    it 'calls form_for with the correct builder' do
      object = instance_double(User)

      allow(view).to receive(:form_for).with(object, hash_including(builder: Tailwinds::Form::Builder))

      view.tramway_form_for(object)

      expect(view).to have_received(:form_for).with(object, hash_including(builder: Tailwinds::Form::Builder))
    end

    it 'forwards arguments and options to form_for' do
      object = instance_double(User)
      options = { key: 'value' }

      allow(view).to receive(:form_for).with(object, hash_including(options))

      view.tramway_form_for(object, **options)

      expect(view).to have_received(:form_for).with(object, hash_including(options))
    end
  end
end
