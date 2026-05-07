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
      text_input: 'h-8 text-sm px-2 py-1',
      select_input: 'h-8 text-sm px-2 py-1',
      file_button: 'h-8 text-sm px-3 py-1',
      submit_button: 'h-8 text-sm px-3 py-1',
      tramway_select_input: 'h-8 text-sm px-2 py-1',
      checkbox_input: 'size-4'
    },
    medium: {
      text_input: 'h-9 text-sm px-3 py-1',
      select_input: 'h-9 text-sm px-3 py-1',
      file_button: 'h-9 text-sm px-4 py-2',
      submit_button: 'h-9 text-sm px-4 py-2',
      tramway_select_input: 'h-9 text-sm px-3 py-1',
      checkbox_input: 'size-4'
    },
    large: {
      text_input: 'h-10 text-base px-4 py-2',
      select_input: 'h-10 text-base px-4 py-2',
      file_button: 'h-10 text-base px-5 py-2',
      submit_button: 'h-10 text-base px-5 py-2',
      tramway_select_input: 'h-10 text-base px-4 py-2',
      checkbox_input: 'size-5'
    }
  }.freeze

  private

  def text_input_base_classes
    theme_classes(
      classic: 'w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm ' \
               'placeholder:text-zinc-500 focus-visible:outline-none focus-visible:ring-1 ' \
               'focus-visible:ring-zinc-300 disabled:cursor-not-allowed disabled:opacity-50'
    )
  end

  def text_area_base_classes
    theme_classes(
      classic: 'min-h-20 w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm ' \
               'placeholder:text-zinc-500 focus-visible:outline-none focus-visible:ring-1 ' \
               'focus-visible:ring-zinc-300 disabled:cursor-not-allowed disabled:opacity-50'
    )
  end

  def select_base_classes
    theme_classes(
      classic: 'w-full rounded-md border border-zinc-800 bg-zinc-950 text-zinc-200 shadow-sm ' \
               'focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-zinc-300 ' \
               'disabled:cursor-not-allowed disabled:opacity-50'
    )
  end

  def file_button_base_classes
    theme_classes(
      classic: 'inline-flex items-center justify-center rounded-md bg-zinc-50 text-sm font-medium text-zinc-950 ' \
               'shadow-sm transition-colors hover:bg-zinc-200 cursor-pointer mt-4'
    )
  end

  def submit_button_base_classes
    theme_classes(
      classic: 'font-medium rounded-md focus-visible:outline-none focus-visible:ring-1 ' \
               'focus-visible:ring-zinc-300 cursor-pointer bg-zinc-50 text-zinc-950 hover:bg-zinc-200 shadow-sm'
    )
  end

  def checkbox_base_classes
    theme_classes(
      classic: 'absolute size-px overflow-hidden whitespace-nowrap border-0 p-0 -m-px [clip-path:inset(50%)]'
    )
  end

  def form_label_classes
    theme_classes(
      classic: 'block text-sm font-medium leading-none text-zinc-300 mb-2'
    )
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
