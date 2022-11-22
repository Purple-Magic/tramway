# frozen_string_literal: true

module Tramway::ApplicationHelper
  include ::FontAwesome5::Rails::IconHelper
  include AdditionalButtonsBuilder
  include ::SmartButtons
  include ::Tramway::CasesHelper
  include ::Tramway::RussianCasesHelper
  include ::Tramway::RecordsHelper
  include ::Tramway::SingletonHelper
  include ::Tramway::NavbarHelper
  include ::Tramway::InputsHelper
  include ::Tramway::FocusGeneratorHelper
  include ::Tramway::ActionsHelper
  include ::Tramway::Collections::Helper
  include ::Tramway::CopyToClipboardHelper
  include ::Tramway::TramwayModelHelper
  include ::Tramway::FrontendHelper

  def object_type(object)
    object_class_name = if object.class.ancestors.include? ::Tramway::ApplicationDecorator
                          object.class.model_class.name
                        else
                          object.class.name
                        end
    ::Tramway.available_models_for(@application_engine || @application.name).map(&:to_s).include?(object_class_name) ? :record : :singleton
  end

  def current_admin
    user = Tramway.admin_model.find_by id: session[:admin_id]
    return false unless user

    Tramway::User::UserDecorator.decorate user
  end
end
