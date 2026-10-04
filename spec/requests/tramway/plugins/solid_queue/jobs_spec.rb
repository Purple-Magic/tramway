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

  before { SolidQueue::Job.destroy_all }

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
    it 'retries all selected failed jobs' do
      job = create_failed_job(class_name: 'FailedJob')

      post '/jobs/bulk_retry', params: { job_ids: [job.id] }

      expect(response).to redirect_to('/jobs')
      expect(job.reload.status).to eq(:ready)
    end
  end

  describe 'POST /jobs/bulk_discard' do
    it 'discards all selected jobs' do
      job = create_ready_job(class_name: 'ReadyJob')

      post '/jobs/bulk_discard', params: { job_ids: [job.id] }

      expect(response).to redirect_to('/jobs')
      expect(SolidQueue::Job.exists?(job.id)).to be(false)
    end
  end

  describe 'POST /jobs/bulk_destroy' do
    it 'destroys all selected jobs' do
      job = create_ready_job(class_name: 'DestroyableJob')

      post '/jobs/bulk_destroy', params: { job_ids: [job.id] }

      expect(response).to redirect_to('/jobs')
      expect(SolidQueue::Job.exists?(job.id)).to be(false)
    end
  end

  describe 'POST /jobs/destroy_all' do
    it 'destroys every job when no filters are set' do
      first_job = create_ready_job(class_name: 'FirstJob')
      second_job = create_ready_job(class_name: 'SecondJob')

      post '/jobs/destroy_all'

      expect(response).to redirect_to('/jobs')
      expect(SolidQueue::Job.exists?(first_job.id)).to be(false)
      expect(SolidQueue::Job.exists?(second_job.id)).to be(false)
    end

    it 'destroys only the jobs matching the status filter' do
      failed_job = create_failed_job(class_name: 'FailedJob')
      ready_job = create_ready_job(class_name: 'ReadyJob')

      post '/jobs/destroy_all', params: { status: 'failed' }

      expect(SolidQueue::Job.exists?(failed_job.id)).to be(false)
      expect(SolidQueue::Job.exists?(ready_job.id)).to be(true)
    end

    it 'destroys only the jobs matching the queue_name filter' do
      mailer_job = create_ready_job(queue_name: 'mailers', class_name: 'MailerJob')
      default_job = create_ready_job(queue_name: 'default', class_name: 'DefaultJob')

      post '/jobs/destroy_all', params: { queue_name: 'mailers' }

      expect(SolidQueue::Job.exists?(mailer_job.id)).to be(false)
      expect(SolidQueue::Job.exists?(default_job.id)).to be(true)
    end

    it 'destroys only the jobs matching the class_name filter' do
      first_job = create_ready_job(class_name: 'FirstJob')
      second_job = create_ready_job(class_name: 'SecondJob')

      post '/jobs/destroy_all', params: { class_name: 'FirstJob' }

      expect(SolidQueue::Job.exists?(first_job.id)).to be(false)
      expect(SolidQueue::Job.exists?(second_job.id)).to be(true)
    end

    it 'destroys only the jobs matching the search query' do
      searchable_job = create_ready_job(class_name: 'SearchableJob')
      other_job = create_ready_job(class_name: 'OtherJob')

      post '/jobs/destroy_all', params: { query: 'Searchable' }

      expect(SolidQueue::Job.exists?(searchable_job.id)).to be(false)
      expect(SolidQueue::Job.exists?(other_job.id)).to be(true)
    end

    it 'combines filters when destroying' do
      matching_job = create_ready_job(queue_name: 'mailers', class_name: 'MailerJob')
      other_queue_job = create_ready_job(queue_name: 'default', class_name: 'MailerJob')

      post '/jobs/destroy_all', params: { queue_name: 'mailers', class_name: 'MailerJob' }

      expect(SolidQueue::Job.exists?(matching_job.id)).to be(false)
      expect(SolidQueue::Job.exists?(other_queue_job.id)).to be(true)
    end
  end
end
