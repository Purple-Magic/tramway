# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Helpers::DecorateHelper, type: :controller do
  let(:controller) { ActionController::Base.new }

  before do
    controller.extend described_class
  end

  describe '#tramway_decorate' do
    context 'with success' do
      context 'with default decorator' do
        it 'decorates object' do
          user = create :user

          expect(UserDecorator).to receive(:decorate).with(user, controller)

          controller.tramway_decorate user
        end

        it 'decorates collection of objects' do
          users = create_list :user, 5

          expect(UserDecorator).to receive(:decorate).with(users, controller)

          controller.tramway_decorate users
        end

        it 'decorates empty collection' do
          users = []

          expect(controller.tramway_decorate(users)).to be_empty
        end
      end

      context 'with specific decorator' do
        it 'decorates object' do
          user = create :user

          expect(UserSpecificDecorator).to receive(:decorate).with(user, controller)

          controller.tramway_decorate user, decorator: UserSpecificDecorator
        end

        it 'decorates collection of objects' do
          users = create_list :user, 5

          expect(UserSpecificDecorator).to receive(:decorate).with(users, controller)

          controller.tramway_decorate users, decorator: UserSpecificDecorator
        end
      end
    end
  end
end
