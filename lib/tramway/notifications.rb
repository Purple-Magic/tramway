# frozen_string_literal: true

module Tramway::Notifications
  def set_notificable_queries(**queries)
    @notificable_queries ||= {}
    @notificable_queries.merge! queries
  end

  def notificable_queries
    @notificable_queries
  end
end
