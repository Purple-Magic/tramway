# frozen_string_literal: true

require 'rails_helper'

describe 'Tramway SolidQueue Plugin Queues', type: :request do
  before do
    SolidQueue::Job.destroy_all
    SolidQueue::Pause.destroy_all
  end

  describe 'GET /queues' do
    it 'lists the queues used by existing jobs' do
      SolidQueue::Job.create!(queue_name: 'mailers', class_name: 'MailerJob', active_job_id: SecureRandom.uuid)

      get '/jobs/queues'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('mailers')
    end
  end

  describe 'POST /queues/:name/pause' do
    it 'pauses the queue' do
      SolidQueue::Job.create!(queue_name: 'mailers', class_name: 'MailerJob', active_job_id: SecureRandom.uuid)

      post '/jobs/queues/mailers/pause'

      expect(response).to redirect_to('/jobs/queues')
      expect(SolidQueue::Queue.find_by_name('mailers')).to be_paused
    end
  end

  describe 'POST /queues/:name/resume' do
    it 'resumes a paused queue' do
      SolidQueue::Job.create!(queue_name: 'mailers', class_name: 'MailerJob', active_job_id: SecureRandom.uuid)
      SolidQueue::Queue.find_by_name('mailers').pause

      post '/jobs/queues/mailers/resume'

      expect(response).to redirect_to('/jobs/queues')
      expect(SolidQueue::Queue.find_by_name('mailers')).not_to be_paused
    end
  end

  describe 'POST /queues/:name/clear' do
    it 'clears all jobs from the queue' do
      SolidQueue::Job.create!(queue_name: 'mailers', class_name: 'MailerJob', active_job_id: SecureRandom.uuid)

      post '/jobs/queues/mailers/clear'

      expect(response).to redirect_to('/jobs/queues')
      expect(SolidQueue::Job.where(queue_name: 'mailers').count).to eq(0)
    end
  end
end
