# frozen_string_literal: true

module Tailwinds
  module Containers
    # Default page container in Tramway
    class NarrowComponent < Tramway::Component::Base
      option :id, optional: true, default: proc { SecureRandom.uuid }
    end
  end
end
