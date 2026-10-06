# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # Lists SolidQueue recurring tasks and lets the user enqueue one immediately
      class RecurringTasksController < ApplicationController
        def index
          @recurring_tasks = ::SolidQueue::RecurringTask.order(:key)
        end

        def enqueue
          recurring_task.enqueue(at: Time.current)

          redirect_to recurring_tasks_path, notice: t('tramway.plugins.solid_queue.notices.enqueued')
        end

        private

        def recurring_task
          @recurring_task ||= ::SolidQueue::RecurringTask.find_by!(key: params.expect(:key))
        end
      end
    end
  end
end
