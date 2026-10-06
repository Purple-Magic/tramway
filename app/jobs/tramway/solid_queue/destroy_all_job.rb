# frozen_string_literal: true

module Tramway
  module SolidQueue
    # Destroys every job matching the given filters, in batches so a large match set
    # doesn't load/destroy everything in a single pass.
    class DestroyAllJob < ApplicationJob
      def perform(filters = {})
        Tramway::SolidQueue::JobsFilter.new(filters).jobs.in_batches(of: BATCH_SIZE, &:destroy_all)
      end
    end
  end
end
