# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Helpers::DecorateHelper, type: :controller do
  let(:controller) { ActionController::Base.new }

  before do
    controller.extend described_class
  end

  describe '#tramway_decorate' do
    context 'with success' do
      it 'decorates object' do
        user = create :user

        expect(Tramway::BaseDecorator).to receive(:decorate).with(user, controller)

        controller.tramway_decorate user
      end

      it 'decorates collection of objects' do
        users = create_list :user, 5

        expect(Tramway::BaseDecorator).to receive(:decorate).with(users, controller)

        controller.tramway_decorate users
      end
    end
  end
end
