# frozen_string_literal: true

module Tramway::Attributes::ViewHelper
  def build_viewable_value(object, attribute)
    value = try(attribute[0]) ? send(attribute[0]) : object.send(attribute[0])
    return state_machine_view(object, attribute[0]) if state_machine? object, attribute[0]

    view_by_value object, value, attribute
  end

  def state_machine?(object, attribute_name)
    attribute_name.to_s.in? object.class.state_machines_names.map(&:to_s)
  end

  def view_by_value(object, value, attribute)
    if value.class.in? [ActiveSupport::TimeWithZone, DateTime, Time]
      datetime_view(attribute[1])
    elsif value.instance_of?(PhotoUploader)
      image_view(object.send(attribute[0]))
    elsif value.instance_of?(FileUploader)
      file_view(object.send(attribute[0]))
    elsif value.is_a? Enumerize::Value
      enumerize_view(value)
    elsif value.is_a? Hash
      yaml_view(value)
    else
      value
    end
  end
end
