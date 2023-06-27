# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Helpers::DecorateHelper, type: :controller do
  let(:controller) { ActionController::Base.new }
  let(:user) { User.create }

  before do
    controller.extend described_class
  end

  describe '#tramway_decorate' do
    context 'with success' do
      it 'decorates object' do
        expect(Tramway::BaseDecorator).to receive(:decorate).with(user, controller)

        controller.tramway_decorate user
      end
    end
  end
end
