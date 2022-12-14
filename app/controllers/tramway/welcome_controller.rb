# frozen_string_literal: true

# FIXME configurate load_path
load "#{Tramway.root}/app/controllers/concerns/auth_management.rb"

class Tramway::WelcomeController < Tramway::ApplicationController
  skip_before_action :check_available!

  # FIXME should be included in Tramway::ApplicationController
  include Tramway::AuthManagement

  before_action :authenticate_user!

  def index
    instance_exec(&::Tramway.welcome_page_actions) if ::Tramway.welcome_page_actions.present?
  end
end
