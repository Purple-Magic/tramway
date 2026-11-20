# frozen_string_literal: true

require 'view_component'

# Base TailwindComponent. Contains base features for all form components.
# Every control type renders exactly one `tramway-form__*` primitive class plus a size modifier.
class TailwindComponent < Tramway::BaseComponent
  option :input
  option :attribute
  option :value, optional: true
  option :options
  option :label
  option :for
  option :hint, optional: true, default: -> {}
  option :size, default: -> { :medium }

  SIZE_MODIFIERS = {
    small: 'sm',
    medium: nil,
    large: 'lg'
  }.freeze

  private

  def text_input_classes
    primitive_classes('tramway-form__input')
  end

  def text_area_classes
    'tramway-form__textarea'
  end

  def select_classes
    primitive_classes('tramway-form__select')
  end

  def file_button_classes
    primitive_classes('tramway-form__file-button')
  end

  def checkbox_classes
    primitive_classes('tramway-form__check-input')
  end

  def tramway_select_trigger_classes
    primitive_classes('tramway-select__trigger')
  end

  def form_hint_classes
    'tramway-form__hint'
  end

  def default_container_classes
    return 'tramway-form__field tramway-form__field--horizontal' if options[:horizontal]

    'tramway-form__field'
  end

  def primitive_classes(base)
    [base, (size_modifier ? "#{base}--#{size_modifier}" : nil)].compact.join(' ')
  end

  def size_modifier
    SIZE_MODIFIERS.fetch(size) { SIZE_MODIFIERS[:medium] }
  end
end
