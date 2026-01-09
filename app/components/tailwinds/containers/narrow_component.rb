# frozen_string_literal: true

module Tailwinds
  module Containers
    # Default page container in Tramway
    class NarrowComponent < Tramway::BaseComponent
      option :id, optional: true, default: proc { SecureRandom.uuid }
      option :options, optional: true, default: proc { {} }
    end
  end
end
