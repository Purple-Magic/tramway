# frozen_string_literal: true

class Tramway::WelcomeController < Tramway::ApplicationController
  skip_before_action :check_available!

  def index
    instance_exec(&::Tramway.welcome_page_actions) if ::Tramway.welcome_page_actions.present?
  end
end
