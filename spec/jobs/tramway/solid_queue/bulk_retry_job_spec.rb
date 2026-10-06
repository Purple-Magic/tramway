# frozen_string_literal: true

require 'rails_helper'

describe Tramway::SolidQueue::BulkRetryJob do
  def create_failed_job(class_name:)
    job = SolidQueue::Job.create!(
      queue_name: 'default', class_name:, active_job_id: SecureRandom.uuid,
      arguments: { 'executions' => 0, 'exception_executions' => {} }
    )
    job.ready_execution.destroy!
    SolidQueue::FailedExecution.create!(job:, exception: StandardError.new('boom'))
    job
  end

  before { SolidQueue::Job.destroy_all }

  it 'retries only the given jobs' do
    selected_job = create_failed_job(class_name: 'SelectedJob')
    other_job = create_failed_job(class_name: 'OtherJob')

    described_class.perform_now([selected_job.id])

    expect(selected_job.reload.status).to eq(:ready)
    expect(other_job.reload.status).to eq(:failed)
  end

  it 'processes the given jobs in batches of 1000' do
    job = create_failed_job(class_name: 'SelectedJob')
    relation = SolidQueue::Job.where(id: job.id)

    allow(SolidQueue::Job).to receive(:where).and_return(relation)
    expect(relation).to receive(:find_each).with(batch_size: described_class::BATCH_SIZE)

    described_class.perform_now([job.id])
  end
end
