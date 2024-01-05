# frozen_string_literal: true

require 'view_component'

# Base TailwindComponent. Contains base features for all tailwind components
class TailwindComponent < ViewComponent::Base
  extend Dry::Initializer[undefined: false]

  option :input
  option :attribute
  option :value, optional: true
  option :options
  option :label
  option :for
end
