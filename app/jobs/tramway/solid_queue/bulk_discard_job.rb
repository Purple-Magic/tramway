# frozen_string_literal: true

module Tramway
  module SolidQueue
    # Discards the given jobs, in batches so a large selection doesn't load everything
    # in a single pass. `discard` is a per-record SolidQueue operation, not a bulk SQL one.
    class BulkDiscardJob < ApplicationJob
      def perform(job_ids)
        ::SolidQueue::Job.where(id: job_ids).find_each(batch_size: BATCH_SIZE, &:discard)
      end
    end
  end
end
