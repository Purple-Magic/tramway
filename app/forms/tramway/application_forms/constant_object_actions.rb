# frozen_string_literal: true

module Tramway::ApplicationForms::ConstantObjectActions
  def delegating(object)
    %i[to_key errors].each { |method| self.class.send(:define_method, method) { object.send method } }
  end

  def build_errors; end

  def attributes
    properties.reduce({}) do |hash, property|
      value = if model.respond_to? :values
                model.values[property.first.to_s]
              else
                model.send(property.first.to_s)
              end
      hash.merge! property.first => value
    end
  end
end
