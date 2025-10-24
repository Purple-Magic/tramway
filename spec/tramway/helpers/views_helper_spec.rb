# frozen_string_literal: true

require 'tramway/helpers/views_helper'
require 'support/view_helpers'

describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_form_for' do
    it 'calls form_for with the correct builder and default size' do
      object = double('User')

      allow(view).to receive(:form_for).with(object, hash_including(builder: Tailwinds::Form::Builder, size: :middle))

      view.tramway_form_for(object)

      expect(view).to have_received(:form_for).with(object,
                                                    hash_including(builder: Tailwinds::Form::Builder, size: :middle))
    end

    it 'forwards arguments and options to form_for' do
      object = double('User')
      options = { key: 'value' }

      expected_options = options.merge(size: :large)

      allow(view).to receive(:form_for).with(object, hash_including(expected_options))

      view.tramway_form_for(object, size: :large, **options)

      expect(view).to have_received(:form_for).with(object, hash_including(expected_options))
    end
  end

  describe '#tramway_table' do
    it 'delegates to tailwinds table component with provided options and block' do
      block = proc {}

      expect(view).to receive(:component) do |name, options:, &received_block|
        expect(name).to eq 'tailwinds/table'
        expect(options).to eq(class: 'table')
        expect(received_block).to eq block
        :component_output
      end

      expect(view.tramway_table(class: 'table', &block)).to eq :component_output
    end
  end

  describe '#tramway_row' do
    it 'delegates to tailwinds row component with extracted options' do
      block = proc {}

      expect(view).to receive(:component) do |name, cells:, href:, options:, &received_block|
        expect(name).to eq 'tailwinds/table/row'
        expect(cells).to eq %w[first second]
        expect(href).to eq '/rows/1'
        expect(options).to eq(class: 'row')
        expect(received_block).to eq block
        :row_output
      end

      result = view.tramway_row(cells: %w[first second], href: '/rows/1', class: 'row', &block)

      expect(result).to eq :row_output
    end
  end

  describe '#tramway_cell' do
    it 'delegates to tailwinds cell component' do
      block = proc {}

      expect(view).to receive(:component) do |name, &received_block|
        expect(name).to eq 'tailwinds/table/cell'
        expect(received_block).to eq block
        :cell_output
      end

      expect(view.tramway_cell(&block)).to eq :cell_output
    end
  end

  describe '#tramway_button' do
    it 'delegates to tailwinds button component with defaults' do
      expect(view).to receive(:component) do |name, text:, path:, method:, color:, type:, size:, options:|
        expect(name).to eq 'tailwinds/button'
        expect(text).to be_nil
        expect(path).to eq '/dashboard'
        expect(method).to eq :get
        expect(color).to be_nil
        expect(type).to be_nil
        expect(size).to be_nil
        expect(options).to eq({})
        :button_output
      end

      expect(view.tramway_button(path: '/dashboard')).to eq :button_output
    end

    it 'delegates to tailwinds button component with custom options' do
      expect(view).to receive(:component) do |name, text:, path:, method:, color:, type:, size:, options:|
        expect(name).to eq 'tailwinds/button'
        expect(text).to eq 'Edit'
        expect(path).to eq '/users/1'
        expect(method).to eq :delete
        expect(color).to eq :red
        expect(type).to eq :outline
        expect(size).to eq :small
        expect(options).to eq(data: { turbo_confirm: 'Are you sure?' })
        :custom_button_output
      end

      expect(
        view.tramway_button(
          path: '/users/1',
          text: 'Edit',
          method: :delete,
          color: :red,
          type: :outline,
          size: :small,
          data: { turbo_confirm: 'Are you sure?' }
        )
      ).to eq :custom_button_output
    end
  end

  describe '#tramway_back_button' do
    it 'delegates to tailwinds back button component' do
      expect(view).to receive(:component).with('tailwinds/back_button') { :back_button }

      expect(view.tramway_back_button).to eq :back_button
    end
  end
end
