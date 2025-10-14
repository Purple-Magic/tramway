# frozen_string_literal: true

require 'view_component'

# Base TailwindComponent. Contains base features for all tailwind components
class TailwindComponent < Tramway::Component::Base
  option :input
  option :attribute
  option :value, optional: true
  option :options
  option :label
  option :for
  option :size, default: -> { :middle }

  SIZE_CLASSES = {
    small: {
      text_input: 'text-sm px-2 py-1',
      select_input: 'text-sm px-2 py-1',
      file_button: 'text-sm px-3 py-1',
      submit_button: 'text-sm px-3 py-1',
      multiselect_input: 'text-sm px-2 py-1'
    },
    middle: {
      text_input: 'text-base px-3 py-2',
      select_input: 'text-base px-3 py-2',
      file_button: 'text-base px-4 py-2',
      submit_button: 'text-base px-4 py-2',
      multiselect_input: 'text-base px-3 py-2'
    },
    large: {
      text_input: 'text-lg px-4 py-3',
      select_input: 'text-lg px-4 py-3',
      file_button: 'text-lg px-5 py-3',
      submit_button: 'text-lg px-5 py-3',
      multiselect_input: 'text-lg px-4 py-3'
    }
  }.freeze

  private

  def size_class(key)
    size_classes = SIZE_CLASSES.fetch(size) { SIZE_CLASSES[:middle] }
    size_classes.fetch(key) { SIZE_CLASSES[:middle].fetch(key) }
  end
end
