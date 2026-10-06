# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # View helpers for rendering SolidQueue job statuses in the plugin dashboard
      module JobsHelper
        STATUS_BADGE_TYPES = {
          ready: :hope,
          claimed: :love,
          scheduled: :fear,
          blocked: :warning,
          failed: :rage,
          finished: :will
        }.freeze

        def solid_queue_status_badge_type(status)
          STATUS_BADGE_TYPES.fetch(status&.to_sym, :default)
        end

        def solid_queue_status_label(status)
          t("tramway.plugins.solid_queue.statuses.#{status}", default: status.to_s.humanize)
        end
      end
    end
  end
end
