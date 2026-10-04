# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # Lists, filters and manages SolidQueue jobs for the plugin dashboard
      class JobsController < ApplicationController
        def index
          @jobs = jobs_filter.jobs.order(id: :desc).page(params[:page])
          @status_counts = jobs_filter.status_counts
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
          Tramway::SolidQueue::BulkRetryJob.perform_later(selected_job_ids)

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.bulk_retry_enqueued')
        end

        def bulk_discard
          Tramway::SolidQueue::BulkDiscardJob.perform_later(selected_job_ids)

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.bulk_discard_enqueued')
        end

        def bulk_destroy
          Tramway::SolidQueue::BulkDestroyJob.perform_later(selected_job_ids)

          redirect_to jobs_path, notice: t('tramway.plugins.solid_queue.notices.bulk_destroy_enqueued')
        end

        def destroy_all
          Tramway::SolidQueue::DestroyAllJob.perform_later(filter_params)

          redirect_to jobs_path(request.query_parameters.except('page')),
                      notice: t('tramway.plugins.solid_queue.notices.destroy_all_enqueued')
        end

        private

        def job
          @job ||= ::SolidQueue::Job.find(params.expect(:id))
        end

        def jobs_filter
          @jobs_filter ||= Tramway::SolidQueue::JobsFilter.new(filter_params)
        end

        def filter_params
          params.permit(:status, :queue_name, :class_name, :query).to_h
        end

        def selected_job_ids
          Array(params[:job_ids]).map(&:to_i)
        end
      end
    end
  end
end
