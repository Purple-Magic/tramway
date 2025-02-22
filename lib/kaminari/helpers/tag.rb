module Kaminari
  module Helpers
    class Tag
      def page_url_for(page)
        if @options[:custom_path_method].present?
          Tramway::Engine.routes.url_helpers.public_send(@options[:custom_path_method], @params.except(:controller, :action).merge(page: page))
        else
          params = params_for(page)
          params[:only_path] = true
          @template.url_for params
        end
      end
    end
  end
end
