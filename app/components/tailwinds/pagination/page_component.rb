# frozen_string_literal: true

module Tailwinds
  module Pagination
    # Kaminari page component for rendering a page button in a pagination
    class PageComponent < Tailwinds::Pagination::Base
      option :page
    end
  end
end
