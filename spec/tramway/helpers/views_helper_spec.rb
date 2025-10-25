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
      object = Struct.new(:id).new(1)

      allow(view).to receive(:form_for).with(object, hash_including(builder: Tailwinds::Form::Builder, size: :middle))

      view.tramway_form_for(object)

      expect(view).to have_received(:form_for).with(object,
                                                    hash_including(builder: Tailwinds::Form::Builder, size: :middle))
    end

    it 'forwards arguments and options to form_for' do
      object = Struct.new(:id).new(2)
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
      captured = {}

      allow(view).to receive(:component) do |name, **kwargs, &received_block|
        captured = { name:, kwargs:, block: received_block }
        :component_output
      end

      result = view.tramway_table(class: 'table', &block)

      expect(result).to eq :component_output
      expect(captured).to eq(name: 'tailwinds/table', kwargs: { options: { class: 'table' } }, block: block)
    end
  end

  describe '#tramway_row' do
    let(:row_block) { proc {} }
    let(:row_component_arguments) do
      { cells: %w[first second], href: '/rows/1', options: { class: 'row' } }
    end
    let(:row_helper_arguments) { { cells: %w[first second], href: '/rows/1', class: 'row' } }

    it 'delegates to tailwinds row component with extracted options' do
      expect(view).to receive(:component).with('tailwinds/table/row', **row_component_arguments) do |&received_block|
        expect(received_block).to be row_block
        :row_output
      end

      expect(view.tramway_row(**row_helper_arguments, &row_block)).to eq :row_output
    end
  end

  describe '#tramway_cell' do
    let(:cell_block) { proc {} }

    it 'delegates to tailwinds cell component' do
      expect(view).to receive(:component).with('tailwinds/table/cell') do |&received_block|
        expect(received_block).to be cell_block
        :cell_output
      end

      expect(view.tramway_cell(&cell_block)).to eq :cell_output
    end
  end

  describe '#tramway_button' do
    let(:default_component_arguments) do
      { text: nil, path: '/dashboard', method: :get, color: nil, type: nil, size: nil, options: {} }
    end

    let(:default_helper_arguments) { { path: '/dashboard' } }

    let(:custom_component_arguments) do
      {
        text: 'Edit',
        path: '/users/1',
        method: :delete,
        color: :red,
        type: :outline,
        size: :small,
        options: { data: { turbo_confirm: 'Are you sure?' } }
      }
    end

    let(:custom_helper_arguments) do
      {
        path: '/users/1',
        text: 'Edit',
        method: :delete,
        color: :red,
        type: :outline,
        size: :small,
        data: { turbo_confirm: 'Are you sure?' }
      }
    end

    it 'delegates to tailwinds button component with defaults' do
      expect(view)
        .to receive(:component)
        .with('tailwinds/button', **default_component_arguments)
        .and_return(:button_output)

      expect(view.tramway_button(**default_helper_arguments)).to eq :button_output
    end

    it 'delegates to tailwinds button component with custom options' do
      expect(view)
        .to receive(:component)
        .with('tailwinds/button', **custom_component_arguments)
        .and_return(:custom_button_output)

      expect(view.tramway_button(**custom_helper_arguments)).to eq :custom_button_output
    end
  end

  describe '#tramway_back_button' do
    it 'delegates to tailwinds back button component' do
      expect(view).to receive(:component).with('tailwinds/back_button').and_return(:back_button)

      expect(view.tramway_back_button).to eq :back_button
    end
  end
end
