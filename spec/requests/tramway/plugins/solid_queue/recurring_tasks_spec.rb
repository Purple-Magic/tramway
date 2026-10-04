# frozen_string_literal: true

require 'rails_helper'

describe 'Tramway SolidQueue Plugin Recurring Tasks', type: :request do
  before { SolidQueue::RecurringTask.destroy_all }

  describe 'GET /recurring_tasks' do
    it 'lists the recurring tasks' do
      stub_const('CleanupJob', Class.new(ApplicationJob) { def perform(*); end })
      SolidQueue::RecurringTask.create!(
        key: 'nightly_cleanup', schedule: '0 3 * * *', class_name: 'CleanupJob', queue_name: 'default'
      )

      get '/jobs/recurring_tasks'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('nightly_cleanup')
      expect(response.body).to include('CleanupJob')
    end
  end

  describe 'POST /recurring_tasks/:key/enqueue' do
    around do |example|
      previous_adapter = ActiveJob::Base.queue_adapter
      ActiveJob::Base.queue_adapter = :solid_queue
      example.run
      ActiveJob::Base.queue_adapter = previous_adapter
    end

    it 'enqueues the recurring task immediately' do
      stub_const('ExampleRecurringJob', Class.new(ApplicationJob) { def perform(*); end })
      SolidQueue::RecurringTask.create!(
        key: 'nightly_cleanup', schedule: '0 3 * * *', class_name: 'ExampleRecurringJob', queue_name: 'default'
      )
      SolidQueue::Job.destroy_all

      post '/jobs/recurring_tasks/nightly_cleanup/enqueue'

      expect(response).to redirect_to('/jobs/recurring_tasks')
      expect(SolidQueue::RecurringExecution.where(task_key: 'nightly_cleanup')).to exist
    end
  end
end
