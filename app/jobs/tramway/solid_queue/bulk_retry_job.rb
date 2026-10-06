# frozen_string_literal: true

module Tramway
  module SolidQueue
    # Retries the given jobs, in batches so a large selection doesn't load everything
    # in a single pass. `retry` is a per-record SolidQueue operation, not a bulk SQL one.
    class BulkRetryJob < ApplicationJob
      def perform(job_ids)
        ::SolidQueue::Job.where(id: job_ids).find_each(batch_size: BATCH_SIZE, &:retry)
      end
    end
  end
end
