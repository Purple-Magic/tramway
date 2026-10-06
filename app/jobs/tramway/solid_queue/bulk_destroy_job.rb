# frozen_string_literal: true

module Tramway
  module SolidQueue
    # Destroys the given jobs, in batches so a large selection doesn't load/destroy
    # everything in a single pass.
    class BulkDestroyJob < ApplicationJob
      def perform(job_ids)
        ::SolidQueue::Job.where(id: job_ids).in_batches(of: BATCH_SIZE, &:destroy_all)
      end
    end
  end
end
