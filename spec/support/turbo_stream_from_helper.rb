# frozen_string_literal: true

module TurboStreamFromHelper
  def turbo_stream_from(*)
    ''
  end
end

ActiveSupport.on_load(:action_view) { include TurboStreamFromHelper }
