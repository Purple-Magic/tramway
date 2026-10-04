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
end
