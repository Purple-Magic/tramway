# frozen_string_literal: true

module Tramway
  module Comments
    # HTML comment that shows in case `show_path` is needed but it's empty
    # It does not show for Rails.env.production
    class ShowPathComponent < Tramway::BaseComponent
      option :decorator_class
    end
  end
end
