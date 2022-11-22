# frozen_string_literal: true

module Tramway::Core::TitleHelper
  def title(page_title = default_title)
    @application ||= Tramway::Core.application&.model_class&.first || Tramway::Core.application
    if @application.present?
      title_text = "#{page_title} | #{@application.try(:title) || @application.public_name}"
      content_for(:title) { title_text }
    else
      Tramway::Error.raise_error(:tramway, :core, :title_helper, :title, :you_should_set_tramway_core_application)
    end
  end

  def default_title
    t('.title')
  end

  def page_title(action, model_name)
    if I18n.locale == :ru
      t("helpers.actions.#{action}") + ' ' + genitive(model_name)
    else
      t("helpers.actions.#{action}") + ' ' + model_name.model_name.human.downcase
    end
  end
end
