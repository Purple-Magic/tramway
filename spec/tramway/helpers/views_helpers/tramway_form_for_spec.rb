# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  def expect_form_for_with_remote_submit(object:, html: nil)
    expected_options = { remote_submit: true }
    expected_options[:html] = html unless html.nil?

    allow(view).to receive(:form_for).with(
      object,
      hash_including(expected_options)
    )
  end

  def expect_received_form_for_with_remote_submit(object:, html: nil)
    expected_options = { remote: true, remote_submit: true }
    expected_options[:html] = html unless html.nil?

    expect(view).to have_received(:form_for).with(
      object,
      hash_including(expected_options)
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

    it 'passes remote_submit when remote is true' do
      object = Struct.new(:id).new(5)

      expect_form_for_with_remote_submit(object:)

      view.tramway_form_for(object, remote: true)

      expect_received_form_for_with_remote_submit(object:)
    end

    it 'preserves html options for remote forms' do
      object = Struct.new(:id).new(6)
      original_onchange = 'window.console.log("changed")'
      options = {
        remote: true,
        html: { class: 'form', onchange: original_onchange }
      }

      allow(view).to receive(:form_for).with(object, hash_including(html: hash_including(class: 'form')))
      expect_form_for_with_remote_submit(object:, html: hash_including(class: 'form', onchange: original_onchange))

      view.tramway_form_for(object, **options)

      expect_received_form_for_with_remote_submit(object:,
                                                  html: hash_including(
                                                    class: 'form', onchange: original_onchange
                                                  ))
      expect(view).to have_received(:form_for).with(object, hash_including(html: hash_including(class: 'form')))
    end
  end
end
