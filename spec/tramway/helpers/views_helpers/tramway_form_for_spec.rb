# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_form_for' do
    it 'calls form_for with the correct builder and default size' do
      object = Struct.new(:id).new(1)

      allow(view).to receive(:form_for).with(object, hash_including(builder: Tailwinds::Form::Builder, size: :medium))

      view.tramway_form_for(object)

      expect(view).to have_received(:form_for).with(
        object, hash_including(builder: Tailwinds::Form::Builder, size: :medium)
      )
    end

    it 'forwards arguments and options to form_for' do
      object = Struct.new(:id).new(2)
      options = { key: 'value' }

      expected_options = options.merge(size: :large)

      allow(view).to receive(:form_for).with(object, hash_including(expected_options))

      view.tramway_form_for(object, size: :large, **options)

      expect(view).to have_received(:form_for).with(object, hash_including(expected_options))
    end

    it 'falls back to medium size when provided size is invalid' do
      object = Struct.new(:id).new(3)

      allow(view).to receive(:form_for).with(object, hash_including(size: :medium))

      view.tramway_form_for(object, size: :huge)

      expect(view).to have_received(:form_for).with(object, hash_including(size: :medium))
    end
  end
end
