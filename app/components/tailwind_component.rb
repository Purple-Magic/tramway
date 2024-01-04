# frozen_string_literal: true

require 'view_component'

# Base TailwindComponent. Contains base features for all tailwind components
class TailwindComponent < ViewComponent::Base
  extend Dry::Initializer[undefined: false]

  option :template
  option :attribute
  option :object_name
  option :options
  option :label
  option :for
end
