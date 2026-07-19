# frozen_string_literal: true

require 'view_component'

# Base TailwindComponent. Contains base features for all tailwind components
class TailwindComponent < Tramway::BaseComponent
  option :input
  option :attribute
  option :value, optional: true
  option :options
  option :label
  option :for
  option :size, default: -> { :medium }

  SIZE_CLASSES = {
    small: {
      text_input: 'text-sm px-2 py-1',
      select_input: 'text-sm px-2 py-1',
      file_button: 'text-sm px-3 py-1',
      submit_button: 'text-sm px-3 py-1',
      tramway_select_input: 'text-sm px-2 py-1 h-10',
      checkbox_input: 'h-4 w-4',
      checkbox_indicator: 'h-3 w-3'
    },
    medium: {
      text_input: 'text-base px-3 py-2',
      select_input: 'text-base px-3 py-2',
      file_button: 'text-base px-4 py-2',
      submit_button: 'text-base px-4 py-2',
      tramway_select_input: 'text-base px-2 py-1 h-12',
      checkbox_input: 'h-5 w-5',
      checkbox_indicator: 'h-4 w-4'
    },
    large: {
      text_input: 'text-xl px-4 py-3',
      select_input: 'text-xl px-4 py-3',
      file_button: 'text-xl px-5 py-3',
      submit_button: 'text-xl px-5 py-3',
      tramway_select_input: 'text-xl px-3 py-2 h-15',
      checkbox_input: 'h-6 w-6',
      checkbox_indicator: 'h-5 w-5'
    }
  }.freeze

  private

  def text_input_base_classes
    'w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-50 shadow-sm transition-colors ' \
      'placeholder:text-zinc-500 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-300 ' \
      'focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-950 disabled:cursor-not-allowed ' \
      'disabled:opacity-50'
  end

  def select_base_classes
    'w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-50 shadow-sm transition-colors ' \
      'appearance-none focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-300 ' \
      'focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-950 disabled:cursor-not-allowed ' \
      'disabled:opacity-50'
  end

  def file_button_base_classes
    'inline-flex items-center justify-center rounded-md border border-zinc-800 bg-zinc-950 text-zinc-50 ' \
      'font-medium shadow-sm transition-colors hover:bg-zinc-900 focus-visible:outline-none ' \
      'focus-visible:ring-2 focus-visible:ring-zinc-300 focus-visible:ring-offset-2 ' \
      'focus-visible:ring-offset-zinc-950 disabled:pointer-events-none disabled:opacity-50 cursor-pointer mt-4'
  end

  def submit_button_base_classes
    'font-medium rounded-md border border-zinc-800 bg-zinc-950 text-zinc-50 shadow-sm transition-colors ' \
      'hover:bg-zinc-900 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-300 ' \
      'focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-950 cursor-pointer'
  end

  def checkbox_base_classes
    'shrink-0 rounded-sm border border-zinc-800 bg-zinc-950 text-zinc-50 shadow-sm transition-colors ' \
      'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-zinc-300 ' \
      'focus-visible:ring-offset-2 focus-visible:ring-offset-zinc-950 disabled:cursor-not-allowed ' \
      'disabled:opacity-50'
  end

  def form_label_classes
    'block text-sm font-medium leading-none mb-2 text-zinc-200 peer-disabled:cursor-not-allowed ' \
      'peer-disabled:opacity-70'
  end

  def default_container_classes
    return if options[:horizontal]

    'mb-4'
  end

  def size_class(key)
    size_classes = SIZE_CLASSES.fetch(size) { SIZE_CLASSES[:medium] }
    size_classes.fetch(key) { SIZE_CLASSES[:medium].fetch(key) }
  end
end
