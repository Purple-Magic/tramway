# frozen_string_literal: true

require 'rails_helper'
require 'kaminari/helpers/tag'

RSpec.describe Kaminari::Helpers::Tag do
  describe '#page_url_for' do
    let(:post) { create :post, aasm_state: :published }
    let(:params) { { controller: 'tramway/entities', action: 'show' } }

    it 'builds path using custom_path_method with passed arguments' do
      tag = described_class.allocate
      tag.instance_variable_set(:@options, { custom_path_method: :admin_post_path, custom_path_arguments: [post.id] })
      tag.instance_variable_set(:@params, params)

      expect(tag.page_url_for(2)).to eq(Tramway::Engine.routes.url_helpers.admin_post_path(post.id, page: 2))
    end

    it 'falls back to default url building when custom_path_method is missing' do
      tag = described_class.allocate
      tag.instance_variable_set(:@options, {})
      tag.instance_variable_set(:@params, params)
      tag.instance_variable_set(:@template, double(url_for: '/fallback'))

      allow(tag).to receive(:params_for).with(3).and_return(params)

      expect(tag.page_url_for(3)).to eq('/fallback')
    end
  end
end
