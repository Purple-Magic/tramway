# frozen_string_literal: true

module Tramway::ApplicationHelper
  include FontAwesome5::Rails::IconHelper
  include SmartButtons
  include Tramway::AuthManagement

  helpers = Dir[Tramway.root + '/app/helpers/tramway/*_helper.rb']
  helpers.each do |helper|
    module_name = helper.split('/')[-2..-1].join('/')[0..-4].camelize.constantize

    include module_name unless Tramway::ApplicationHelper
  end

  def object_type(object)
    object_class_name = if object.class.ancestors.include? ::Tramway::ApplicationDecorator
                          object.class.model_class.name
                        else
                          object.class.name
                        end
    ::Tramway.available_models_for(@application_engine || @application.name).map(&:to_s).include?(object_class_name) ? :record : :singleton
  end
end
