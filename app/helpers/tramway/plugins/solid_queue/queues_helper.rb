# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # View helpers for rendering SolidQueue queue throughput in the plugin dashboard
      module QueuesHelper
        THROUGHPUT_WINDOW = 5.minutes

        def solid_queue_throughput_label(queue)
          t('tramway.plugins.solid_queue.queues.throughput_value', default: '%<rate>s/min',
                                                                   rate: solid_queue_throughput(queue))
        end

        def solid_queue_throughput(queue)
          finished_count = ::SolidQueue::Job.where(queue_name: queue.name, finished_at: THROUGHPUT_WINDOW.ago..).count

          (finished_count / THROUGHPUT_WINDOW.in_minutes).round(1)
        end
      end
    end
  end
end
