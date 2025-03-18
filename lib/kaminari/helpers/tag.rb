# frozen_string_literal: true

module Kaminari
  module Helpers
    # Monkey patch for Kaminari::Helpers::Tag to support :custom_path_method
    # :reek:InstanceVariableAssumption { enabled: false }
    class Tag
      def page_url_for(page)
        custom_path_method = @options[:custom_path_method]

        if custom_path_method.present?
          Tramway::Engine.routes.url_helpers.public_send(
            custom_path_method,
            @params.except(:controller, :action).merge(page: page)
          )
        else
          params = params_for(page)
          @template.url_for params.merge(only_path: true)
        end
      end
    end
  end
end
