# frozen_string_literal: true

module Tramway
  module Plugins
    module SolidQueue
      # Lists SolidQueue queues and lets the user pause/resume/clear them
      class QueuesController < ApplicationController
        def index
          @queues = ::SolidQueue::Queue.all.sort_by(&:name)
        end

        def pause
          queue.pause

          redirect_to queues_path, notice: t('tramway.plugins.solid_queue.notices.paused')
        end

        def resume
          queue.resume

          redirect_to queues_path, notice: t('tramway.plugins.solid_queue.notices.resumed')
        end

        def clear
          queue.clear

          redirect_to queues_path, notice: t('tramway.plugins.solid_queue.notices.cleared')
        end

        private

        def queue
          @queue ||= ::SolidQueue::Queue.find_by_name(params.expect(:name))
        end
      end
    end
  end
end
