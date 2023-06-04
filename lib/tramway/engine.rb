# frozen_string_literal: true

module Tramway
  # Our plugin is the Rails::Engine
  #
  class Engine < ::Rails::Engine
    isolate_namespace Tramway
  end
end
