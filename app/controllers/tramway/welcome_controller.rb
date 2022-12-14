# frozen_string_literal: true

# FIXME configurate load_path
require_relative 'concerns/auth_management'

class Tramway::WelcomeController < Tramway::ApplicationController
  # skip_before_action :check_available!
  include Tramway::AuthManagement

  before_action :authenticate_user!

  def index
    instance_exec(&::Tramway.welcome_page_actions) if ::Tramway.welcome_page_actions.present?
  end
end
