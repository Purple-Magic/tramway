# frozen_string_literal: true

module TurboStreamFromHelper
  def turbo_stream_from(*)
    ''
  end
end

ActionView::Base.include(TurboStreamFromHelper)
