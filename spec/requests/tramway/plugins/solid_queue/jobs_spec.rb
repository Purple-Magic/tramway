# frozen_string_literal: true

require 'rails_helper'

describe 'Tramway SolidQueue Plugin Jobs', type: :request do
  def job_arguments
    { 'executions' => 0, 'exception_executions' => {} }
  end

  def create_ready_job(queue_name: 'default', class_name: 'ExampleJob')
    SolidQueue::Job.create!(queue_name:, class_name:, active_job_id: SecureRandom.uuid, arguments: job_arguments)
  end

  def create_scheduled_job(queue_name: 'default', class_name: 'ExampleJob')
    SolidQueue::Job.create!(
      queue_name:, class_name:, active_job_id: SecureRandom.uuid, scheduled_at: 1.hour.from_now,
      arguments: job_arguments
    )
  end

  def create_failed_job(queue_name: 'default', class_name: 'ExampleJob')
    job = create_ready_job(queue_name:, class_name:)
    job.ready_execution.destroy!
    SolidQueue::FailedExecution.create!(job:, exception: StandardError.new('Something went wrong'))
    job
  end

  def create_finished_job(queue_name: 'default', class_name: 'ExampleJob')
    job = create_ready_job(queue_name:, class_name:)
    job.update!(finished_at: Time.current)
    job
  end

  def job_row_marker(job)
    "tramway-solid-queue-job-#{job.id}"
  end

  def enqueued_job(class_name)
    SolidQueue::Job.find_by(class_name:)
  end

  before { SolidQueue::Job.destroy_all }

  around do |example|
    previous_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :solid_queue
    example.run
    ActiveJob::Base.queue_adapter = previous_adapter
  end

  describe 'GET /jobs' do
    it 'lists jobs' do
      create_ready_job(class_name: 'FirstJob')

      get '/jobs'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('FirstJob')
    end

    it 'wraps the status filters and the job table in auto-refresh targets, so the page updates without reload' do
      create_ready_job(class_name: 'FirstJob')

      get '/jobs'

      expect(response.body).to include('id="tramway-solid-queue-jobs-status-filters"')
      expect(response.body).to include('id="tramway-solid-queue-jobs-table"')
      expect(response.body).to include('data-controller="tramway--auto-refresh"')
    end

    it 'filters by status' do
      ready_job = create_ready_job(class_name: 'ReadyJob')
      failed_job = create_failed_job(class_name: 'FailedJob')

      get '/jobs', params: { status: 'failed' }

      expect(response.body).to include(job_row_marker(failed_job))
      expect(response.body).not_to include(job_row_marker(ready_job))
    end

    it 'filters by queue_name' do
      mailer_job = create_ready_job(queue_name: 'mailers', class_name: 'MailerJob')
      default_job = create_ready_job(queue_name: 'default', class_name: 'DefaultJob')

      get '/jobs', params: { queue_name: 'mailers' }

      expect(response.body).to include(job_row_marker(mailer_job))
      expect(response.body).not_to include(job_row_marker(default_job))
    end

    it 'filters by class_name' do
      first_job = create_ready_job(class_name: 'FirstJob')
      second_job = create_ready_job(class_name: 'SecondJob')

      get '/jobs', params: { class_name: 'FirstJob' }

      expect(response.body).to include(job_row_marker(first_job))
      expect(response.body).not_to include(job_row_marker(second_job))
    end

    it 'searches by class name or active_job_id' do
      searchable_job = create_ready_job(class_name: 'SearchableJob')
      other_job = create_ready_job(class_name: 'OtherJob')

      get '/jobs', params: { query: 'Searchable' }

      expect(response.body).to include(job_row_marker(searchable_job))
      expect(response.body).not_to include(job_row_marker(other_job))
    end

    it 'searches by numeric id' do
      job = create_ready_job(class_name: 'FirstJob')
      other_job = create_ready_job(class_name: 'SecondJob')

      get '/jobs', params: { query: job.id.to_s }

      expect(response.body).to include(job_row_marker(job))
      expect(response.body).not_to include(job_row_marker(other_job))
    end
  end

  describe 'GET /jobs/:id' do
    it 'shows the job' do
      job = create_ready_job(class_name: 'ShowableJob')

      get "/jobs/#{job.id}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('ShowableJob')
    end

    it 'wraps the job details in an auto-refresh target, so the page updates without reload' do
      job = create_ready_job(class_name: 'ShowableJob')

      get "/jobs/#{job.id}"

      expect(response.body).to include('id="tramway-solid-queue-job-details"')
      expect(response.body).to include('data-controller="tramway--auto-refresh"')
    end

    it 'shows the failure details for a failed job' do
      job = create_failed_job(class_name: 'FailedJob')

      get "/jobs/#{job.id}"

      expect(response.body).to include('Something went wrong')
    end
  end

  describe 'POST /jobs/:id/retry' do
    it 'retries a failed job, moving it back to ready' do
      job = create_failed_job(class_name: 'FailedJob')

      post "/jobs/#{job.id}/retry"

      expect(response).to redirect_to('/jobs')
      expect(job.reload.status).to eq(:ready)
    end
  end

  describe 'POST /jobs/:id/discard' do
    it 'discards a job, removing it entirely' do
      job = create_ready_job(class_name: 'ReadyJob')

      post "/jobs/#{job.id}/discard"

      expect(response).to redirect_to('/jobs')
      expect(SolidQueue::Job.exists?(job.id)).to be(false)
    end
  end

  describe 'DELETE /jobs/:id' do
    it 'destroys the job' do
      job = create_ready_job(class_name: 'DestroyableJob')

      delete "/jobs/#{job.id}"

      expect(response).to redirect_to('/jobs')
      expect(SolidQueue::Job.exists?(job.id)).to be(false)
    end
  end

  describe 'POST /jobs/bulk_retry' do
    it 'enqueues a background job on the dedicated queue, without retrying inline' do
      job = create_failed_job(class_name: 'FailedJob')

      post '/jobs/bulk_retry', params: { job_ids: [job.id] }

      expect(response).to redirect_to('/jobs')
      expect(job.reload.status).to eq(:failed)

      enqueued = enqueued_job('Tramway::SolidQueue::BulkRetryJob')
      expect(enqueued.queue_name).to eq('tramway_solid_queue_bulk_actions')
      expect(enqueued.arguments['arguments']).to eq([[job.id]])
    end
  end

  describe 'POST /jobs/bulk_discard' do
    it 'enqueues a background job on the dedicated queue, without discarding inline' do
      job = create_ready_job(class_name: 'ReadyJob')

      post '/jobs/bulk_discard', params: { job_ids: [job.id] }

      expect(response).to redirect_to('/jobs')
      expect(SolidQueue::Job.exists?(job.id)).to be(true)

      enqueued = enqueued_job('Tramway::SolidQueue::BulkDiscardJob')
      expect(enqueued.queue_name).to eq('tramway_solid_queue_bulk_actions')
      expect(enqueued.arguments['arguments']).to eq([[job.id]])
    end
  end

  describe 'POST /jobs/bulk_destroy' do
    it 'enqueues a background job on the dedicated queue, without destroying inline' do
      job = create_ready_job(class_name: 'DestroyableJob')

      post '/jobs/bulk_destroy', params: { job_ids: [job.id] }

      expect(response).to redirect_to('/jobs')
      expect(SolidQueue::Job.exists?(job.id)).to be(true)

      enqueued = enqueued_job('Tramway::SolidQueue::BulkDestroyJob')
      expect(enqueued.queue_name).to eq('tramway_solid_queue_bulk_actions')
      expect(enqueued.arguments['arguments']).to eq([[job.id]])
    end
  end

  describe 'POST /jobs/destroy_all' do
    it 'enqueues a background job with the current filters, without destroying inline' do
      first_job = create_ready_job(class_name: 'FirstJob')

      post '/jobs/destroy_all', params: { status: 'ready', queue_name: 'default', class_name: 'FirstJob' }

      expect(response).to redirect_to('/jobs')
      expect(SolidQueue::Job.exists?(first_job.id)).to be(true)

      enqueued = enqueued_job('Tramway::SolidQueue::DestroyAllJob')
      expect(enqueued.queue_name).to eq('tramway_solid_queue_bulk_actions')
      expect(enqueued.arguments['arguments'].first).to include(
        'status' => 'ready', 'queue_name' => 'default', 'class_name' => 'FirstJob'
      )
    end

    it 'enqueues a background job with no filters when none are given' do
      post '/jobs/destroy_all'

      expect(response).to redirect_to('/jobs')

      enqueued = enqueued_job('Tramway::SolidQueue::DestroyAllJob')
      expect(enqueued.arguments['arguments'].first.except('_aj_hash_with_indifferent_access')).to eq({})
    end
  end
end
