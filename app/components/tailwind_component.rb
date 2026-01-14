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

  def text_input_base_classes
    theme_classes(
      classic: 'w-full rounded-xl border border-gray-200 bg-gray-100 text-gray-700 shadow-inner ' \
               'focus:outline-none focus:ring-2 focus:ring-gray-300 placeholder-gray-400 ' \
               'dark:bg-gray-900 dark:border-gray-700 dark:text-gray-100 dark:placeholder-gray-500 ' \
               'dark:focus:ring-gray-600'
    )
  end

  def select_base_classes
    theme_classes(
      classic: 'w-full rounded-xl border border-gray-200 bg-gray-100 text-gray-700 shadow-inner ' \
               'focus:outline-none focus:ring-2 focus:ring-gray-300 disabled:cursor-not-allowed ' \
               'disabled:bg-gray-200 disabled:text-gray-400 dark:bg-gray-900 dark:border-gray-700 ' \
               'dark:text-gray-100 dark:focus:ring-gray-600 dark:disabled:bg-gray-800 ' \
               'dark:disabled:text-gray-500'
    )
  end

  def file_button_base_classes
    theme_classes(
      classic: 'inline-block text-blue-800 font-semibold rounded-xl cursor-pointer mt-4 bg-blue-100 ' \
               'hover:bg-blue-200 shadow-md dark:bg-blue-900 dark:text-blue-100 dark:hover:bg-blue-800'
    )
  end

  def submit_button_base_classes
    theme_classes(
      classic: 'font-semibold rounded-xl focus:outline-none focus:ring-2 focus:ring-red-200 cursor-pointer ' \
               'text-red-800 bg-red-100 hover:bg-red-200 shadow-md dark:bg-red-900 dark:text-red-100 ' \
               'dark:hover:bg-red-800 dark:focus:ring-red-700'
    )
  end

  def form_label_classes
    theme_classes(
      classic: 'block text-sm font-semibold mb-2 text-gray-700 dark:text-gray-200'
    )
  end

  def size_class(key)
    size_classes = SIZE_CLASSES.fetch(size) { SIZE_CLASSES[:middle] }
    size_classes.fetch(key) { SIZE_CLASSES[:middle].fetch(key) }
  end
end
