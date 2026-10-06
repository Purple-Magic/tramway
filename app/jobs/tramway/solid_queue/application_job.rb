# frozen_string_literal: true

module Tramway
  module SolidQueue
    # Base job for the plugin's bulk jobs actions (retry/discard/destroy), routed to their
    # own dedicated worker queue so a large bulk action can't starve other application jobs.
    # The `tramway:install` generator configures this queue with 20 worker threads.
    class ApplicationJob < ActiveJob::Base
      BATCH_SIZE = 1000

      queue_as :tramway_solid_queue_bulk_actions
    end
  end
end
