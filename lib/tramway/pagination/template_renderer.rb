module Tramway
  module Pagination
    class TemplateRenderer < ActionView::Base
      def url_for(params)
        binding.pry
      end
    end
  end
  end
