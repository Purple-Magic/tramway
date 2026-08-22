# frozen_string_literal: true

require 'rails_helper'

describe Tramway::Engine do
  describe '.asset paths' do
    it 'resolves the Font Awesome stylesheet and adds the font directory to the asset load path' do
      font_awesome_root = FontAwesome::Rails::Engine.root.join('app/assets')
      view = ActionController::Base.new.view_context

      expect(Rails.application.config.assets.paths.map(&:to_s)).to include(
        font_awesome_root.join('fonts').to_s
      )
      expect(view.stylesheet_path('font-awesome')).to eq('/assets/font-awesome.css')
    end
  end
end
