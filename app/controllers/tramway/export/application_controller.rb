# frozen_string_literal: true

class Tramway::Export::ApplicationController < Tramway::ApplicationController
  before_action :authenticate_admin!
end
