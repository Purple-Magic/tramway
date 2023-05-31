# frozen_string_literal: true

module Tramway
  # Tramway gem is a Rails Engine, so we need this class
  #
  class Engine < ::Rails::Engine
    isolate_namespace Tramway
  end
end
