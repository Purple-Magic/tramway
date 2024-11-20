module Tramway
  module ApplicationHelper
    include Tramway::Decorators::ClassHelper

    def page_title
      @model_class.model_name.human.pluralize
    end

    def component(name, *, **, &)
      render("#{name}_component".classify.constantize.new(*, **), &)
    end

    def pagination_classes(klass: nil)
      "cursor-pointer px-3 py-2 font-medium text-purple-700 bg-white rounded-md hover:bg-purple-100 dark:text-white dark:bg-gray-800 dark:hover:bg-gray-700 #{klass}"
    end
  end
end
