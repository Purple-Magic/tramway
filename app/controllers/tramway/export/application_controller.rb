# frozen_string_literal: true

module Tramway
  module Export
    class ApplicationController < Tramway::ApplicationController
      before_action :authenticate_admin!
    end
  end
end
