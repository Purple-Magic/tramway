module Tramway
  module ApplicationHelper
    include Tramway::Decorators::ClassHelper

    def page_title
      @model_class.model_name.human.pluralize
    end
  end
end
