module Tramway::StateMachineButtonsHelper
  def state_events_buttons(object, state_method: :state, controller:, action:, parameters: {}, without: nil, namespace: nil, model_param_name: nil, button_options: {})
    model_name = object.model.model_name.name.underscore
    model_param_name ||= model_name
    excepted_actions = without.is_a?(Array) ? without.map(&:to_sym) : [without.to_sym] if without
    transitions = object.model.aasm(state_method).permitted_transitions.reject do |t|
      excepted_actions.present? && excepted_actions.include?(t[:event])
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

  def button(event:, model_name:, object:, state_method:, controller:, action:, namespace:, parameters:, model_param_name:, form_options:)
    attributes = { aasm_event: event }
    concat(
      patch_button(
        record: object.model,
        controller: controller,
        action: action,
        parameters: parameters,
        attributes: attributes,
        model_name: model_param_name,
        button_options: { class: "btn btn-sm btn-xs btn-#{object.send("#{state_method}_button_color", event)}" },
        form_options: form_options
      ) do
        I18n.t("state_machines.#{object.model.class.name.underscore}.#{state_method}.events.#{object.model.aasm(state_method).events.select { |ev| ev.name == event }.first.name}")
      end
    )
  end
end
