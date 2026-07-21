# frozen_string_literal: true

require 'rails_helper'

describe Tramway::EntitiesController, type: :controller do
  describe '#set_associations' do
    let(:user) { build_stubbed :user }
    let(:post) { build_stubbed :post, user: }
    let(:record) { Admin::PostDecorator.new(post) }

    before do
      allow(record).to receive(:show_associations).and_return(%i[reactions])
      allow(controller).to receive(:model_class).and_return(Post)

      controller.instance_variable_set(:@record, record)
    end

    it 'raises a clear error when a configured show association is not defined on the model' do
      expect { controller.send(:set_associations) }
        .to raise_error(RuntimeError, 'You must define reactions association in the Post')
    end
  end
end
