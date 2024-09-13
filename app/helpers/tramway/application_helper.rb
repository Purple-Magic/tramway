module Tramway
  module ApplicationHelper
    def page_title
      @model_class.model_name.human.pluralize
    end
  end
end
