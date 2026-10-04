# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # Lists, filters and manages SolidQueue jobs for the plugin dashboard
      class JobsController < ApplicationController
        STATUS_FILTERS = {
          'ready' => ->(relation) { relation.joins(:ready_execution) },
          'claimed' => ->(relation) { relation.joins(:claimed_execution) },
          'scheduled' => ->(relation) { relation.joins(:scheduled_execution) },
          'blocked' => ->(relation) { relation.joins(:blocked_execution) },
          'failed' => ->(relation) { relation.joins(:failed_execution) },
          'finished' => ->(relation) { relation.finished }
        }.freeze

        def index
          @jobs = filtered_jobs.order(id: :desc).page(params[:page])
          @status_counts = status_counts
          @queue_names = ::SolidQueue::Job.distinct.order(:queue_name).pluck(:queue_name)
          @class_names = ::SolidQueue::Job.distinct.order(:class_name).pluck(:class_name)
        end

        def show
          @job = job
        end

        def destroy
          job.destroy

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.destroyed')
        end

        def retry
          job.retry

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.retried')
        end

        def discard
          job.discard

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.discarded')
        end

        def bulk_retry
          selected_jobs.each(&:retry)

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.retried')
        end

        def bulk_discard
          selected_jobs.each(&:discard)

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.discarded')
        end

        def bulk_destroy
          selected_jobs.find_each(&:destroy)

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.destroyed')
        end

        def destroy_all
          filtered_jobs.find_each(&:destroy)

          redirect_to jobs_path(request.query_parameters.except('page')),
                      notice: t('tramway.plugins.solid_queue.notices.destroyed')
        end

        private

        def job
          @job ||= ::SolidQueue::Job.find(params.expect(:id))
        end

        def selected_jobs
          ::SolidQueue::Job.where(id: Array(params[:job_ids]))
        end

        def filtered_jobs
          relation = apply_status_filter(::SolidQueue::Job.all)
          relation = relation.where(queue_name: params[:queue_name]) if params[:queue_name].present?
          relation = relation.where(class_name: params[:class_name]) if params[:class_name].present?

          apply_search(relation).distinct
        end

        def apply_status_filter(relation)
          STATUS_FILTERS.fetch(params[:status]) { ->(rel) { rel } }.call(relation)
        end

        def apply_search(relation)
          query = params[:query].to_s.strip

          return relation if query.blank?

          return relation.where(id: query) if query.match?(/\A\d+\z/)

          relation.where('class_name LIKE :query OR active_job_id LIKE :query', query: "%#{query}%")
        end

        def status_counts
          STATUS_FILTERS.transform_values { |scope| scope.call(::SolidQueue::Job.all).count }
        end
      end
    end
  end
end
