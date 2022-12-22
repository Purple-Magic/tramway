# frozen_string_literal: true

require 'spec_helper'
require 'factory_bot'
require 'rspec/rails'
require 'web_driver_helper'

RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers
  config.before(:all) do
    FactoryBot.reload
  end
  config.include FactoryBot::Syntax::Methods
  config.infer_spec_type_from_file_location!

  ActiveRecord::Base.logger.level = 1
  I18n.locale = :ru
end
