# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_form_for' do
    it 'calls form_for with the correct builder and default size' do
      object = instance_double(User)

      allow(view).to receive(:form_for).with(object, hash_including(builder: Tailwinds::Form::Builder, size: :middle))

      view.tramway_form_for(object)

      expect(view).to have_received(:form_for).with(object,
                                                    hash_including(builder: Tailwinds::Form::Builder, size: :middle))
    end

    it 'forwards arguments and options to form_for' do
      object = instance_double(User)
      options = { key: 'value' }

      expected_options = options.merge(size: :large)

      allow(view).to receive(:form_for).with(object, hash_including(expected_options))

      view.tramway_form_for(object, size: :large, **options)

      expect(view).to have_received(:form_for).with(object, hash_including(expected_options))
    end
  end
end
