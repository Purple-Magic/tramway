# frozen_string_literal: true

module Tramway
  module Helpers
    module ComponentHelper
      def component(name, *, **, &)
        render("#{name}_component".classify.constantize.new(*, **), &)
      end
    end
  end
end
