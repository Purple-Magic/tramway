# frozen_string_literal: true

module Tramway::StateMachineButtonsHelper
  def state_events_buttons(object, **options)
    options.each do |(key, value)|
      define_method(key) { value }
    end
    model_name = object.model.model_name.name.underscore
    model_param_name ||= model_name
    transitions = object.model.aasm(state_method).permitted_transitions.reject do |t|
      excepted_actions(without).present? && excepted_actions(without).include?(t[:event])
    end
    content_tag(:div, class: 'btn-group-vertical') do
      transitions.each do |event|
        button(
          event: event[:event],
          model_name: model_name,
          object: object,
          state_method: state_method,
          controller: controller,
          action: action,
          namespace: namespace,
          parameters: parameters,
          model_param_name: model_param_name,
          form_options: button_options
        )
      end
    end
  end

  private

  def excepted_actions(without)
    return unless without

    without.is_a?(Array) ? without.map(&:to_sym) : [without.to_sym]
  end

  def button(**options)
    event = options[:event]

    concat(
      patch_button(patch_button_options(event, options)) do
        model = options[:object].model
        class_name = model.class.name.underscore
        actual_event = model.aasm(options[:state_method]).events.select { |ev| ev.name == event }
        I18n.t("state_machines.#{class_name}.#{options[:state_method]}.events.#{actual_event}")
      end
    )
  end

  def patch_button_options(event, options)
    attributes = { aasm_event: event }
    css_class = "btn btn-sm btn-xs btn-#{options[:object].send("#{options[:state_method]}_button_color", event)}"

    {
      record: options[:object].model,
      controller: options[:controller],
      action: options[:action],
      parameters: options[:parameters],
      attributes: attributes,
      model_name: options[:model_param_name],
      button_options: { class: css_class },
      form_options: options[:form_options]
    }
  end
end
