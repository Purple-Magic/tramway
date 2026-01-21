# frozen_string_literal: true

require 'rails_helper'
require 'tramway/helpers/views_helper'
require 'support/view_helpers'

RSpec.describe Tramway::Helpers::ViewsHelper, type: :view do
  before do
    described_class.include ViewHelpers
    view.extend described_class
  end

  describe '#tramway_button' do
    let(:default_component_arguments) do
      {
        text: nil,
        path: '/dashboard',
        method: :get,
        form_options: {},
        color: nil,
        type: nil,
        size: nil,
        tag: nil,
        options: {}
      }
    end

    let(:default_helper_arguments) { { path: '/dashboard' } }

    it 'delegates to tailwinds button component with defaults' do
      expect(view)
        .to receive(:component)
        .with('tailwinds/button', **default_component_arguments)
        .and_return(:button_output)

      expect(view.tramway_button(**default_helper_arguments)).to eq :button_output
    end

    context 'with link arguments' do
      let(:link_component_arguments) do
        default_component_arguments.merge(tag: :a)
      end

      let(:link_helper_arguments) do
        default_helper_arguments.merge(tag: :a)
      end

      it 'delegates to tailwinds button component when rendering a link' do
        expect(view)
          .to receive(:component)
          .with('tailwinds/button', **link_component_arguments)
          .and_return(:link_button_output)

        expect(view.tramway_button(**link_helper_arguments)).to eq :link_button_output
      end
    end

    context 'with custom arguments' do
      context 'with all default arguments' do
        let(:custom_component_arguments) do
          {
            text: 'Edit',
            path: '/users/1',
            method: :delete,
            tag: nil,
            color: :red,
            form_options: {},
            type: :primary,
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
            form_options: {},
            type: :primary,
            size: :small,
            data: { turbo_confirm: 'Are you sure?' }
          }
        end

        it 'delegates to tailwinds button component with custom options' do
          expect(view)
            .to receive(:component)
            .with('tailwinds/button', **custom_component_arguments)
            .and_return(:custom_button_output)

          expect(view.tramway_button(**custom_helper_arguments)).to eq :custom_button_output
        end
      end

      context 'with form options' do
        let(:form_component_arguments) do
          default_component_arguments.merge(form_options: { data: { turbo_frame: '_top' } })
        end

        let(:form_helper_arguments) do
          default_helper_arguments.merge(form_options: { data: { turbo_frame: '_top' } })
        end

        it 'delegates form options to the tailwinds button component' do
          expect(view)
            .to receive(:component)
            .with('tailwinds/button', **form_component_arguments)
            .and_return(:form_button_output)

          expect(view.tramway_button(**form_helper_arguments)).to eq :form_button_output
        end
      end
    end
  end
end
