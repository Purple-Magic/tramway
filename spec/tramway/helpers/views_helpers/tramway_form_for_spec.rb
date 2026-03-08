# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  let(:remote_onchange) do
    "if (event.target && this.contains(event.target) && event.target.type !== 'submit') { this.requestSubmit(); }"
  end

  def expect_form_for_with_remote_onchange(object:, onchange:)
    allow(view).to receive(:form_for).with(
      object,
      hash_including(
        remote: true,
        html: hash_including(
          onchange:
        )
      )
    )
  end

  def expect_received_form_for_with_remote_onchange(object:, onchange:)
    expect(view).to have_received(:form_for).with(
      object,
      hash_including(
        remote: true,
        html: hash_including(
          onchange:
        )
      )
    )
  end

  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_form_for' do
    it 'calls form_for with the correct builder and default size' do
      object = Struct.new(:id).new(1)

      allow(view).to receive(:form_for).with(object, hash_including(builder: Tramway::Form::Builder, size: :medium))

      view.tramway_form_for(object)

      expect(view).to have_received(:form_for).with(
        object, hash_including(builder: Tramway::Form::Builder, size: :medium)
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

    it 'passes through horizontal option' do
      object = Struct.new(:id).new(4)

      allow(view).to receive(:form_for).with(object, hash_including(horizontal: true))

      view.tramway_form_for(object, horizontal: true)

      expect(view).to have_received(:form_for).with(object, hash_including(horizontal: true))
    end

    it 'falls back to medium size when provided size is invalid' do
      object = Struct.new(:id).new(3)

      allow(view).to receive(:form_for).with(object, hash_including(size: :medium))

      view.tramway_form_for(object, size: :huge)

      expect(view).to have_received(:form_for).with(object, hash_including(size: :medium))
    end

    it 'adds remote onchange behavior when remote is true' do
      object = Struct.new(:id).new(5)

      expect_form_for_with_remote_onchange(object:, onchange: remote_onchange)

      view.tramway_form_for(object, remote: true)

      expect_received_form_for_with_remote_onchange(object:, onchange: remote_onchange)
    end

    it 'preserves html options and appends existing onchange for remote forms' do
      object = Struct.new(:id).new(6)
      original_onchange = 'window.console.log("changed")'
      merged_onchange = "#{original_onchange}; #{remote_onchange}"
      options = {
        remote: true,
        html: {
          class: 'form',
          onchange: original_onchange
        }
      }

      allow(view).to receive(:form_for).with(object, hash_including(html: hash_including(class: 'form')))
      expect_form_for_with_remote_onchange(object:, onchange: merged_onchange)

      view.tramway_form_for(object, **options)

      expect_received_form_for_with_remote_onchange(object:, onchange: merged_onchange)
      expect(view).to have_received(:form_for).with(object, hash_including(html: hash_including(class: 'form')))
    end
  end
end
