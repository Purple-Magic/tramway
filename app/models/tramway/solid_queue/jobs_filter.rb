# frozen_string_literal: true

module Tramway
  module SolidQueue
    # Shared status/queue/class/search filtering for SolidQueue jobs, used by both the
    # jobs controller (for the index page) and the background jobs that process a
    # filtered set of jobs (e.g. "Destroy all"), since a job's `perform` only receives
    # plain serializable arguments, not a live `ActionController::Parameters`.
    class JobsFilter
      STATUS_FILTERS = {
        'ready' => ->(relation) { relation.joins(:ready_execution) },
        'claimed' => ->(relation) { relation.joins(:claimed_execution) },
        'scheduled' => ->(relation) { relation.joins(:scheduled_execution) },
        'blocked' => ->(relation) { relation.joins(:blocked_execution) },
        'failed' => ->(relation) { relation.joins(:failed_execution) },
        'finished' => ->(relation) { relation.finished }
      }.freeze

      def initialize(filters = {})
        @filters = filters.to_h.stringify_keys
      end

      def jobs
        relation = apply_status_filter(::SolidQueue::Job.all)
        relation = relation.where(queue_name: filters['queue_name']) if filters['queue_name'].present?
        relation = relation.where(class_name: filters['class_name']) if filters['class_name'].present?

        apply_search(relation).distinct
      end

      def status_counts
        STATUS_FILTERS.transform_values { |scope| scope.call(::SolidQueue::Job.all).count }
      end

      private

      attr_reader :filters

      def apply_status_filter(relation)
        STATUS_FILTERS.fetch(filters['status']) { ->(rel) { rel } }.call(relation)
      end

      def apply_search(relation)
        query = filters['query'].to_s.strip

        return relation if query.blank?
        return relation.where(id: query) if query.match?(/\A\d+\z/)

        relation.where('class_name LIKE :query OR active_job_id LIKE :query', query: "%#{query}%")
      end
    end
  end
end
