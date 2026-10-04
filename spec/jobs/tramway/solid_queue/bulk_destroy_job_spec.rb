# frozen_string_literal: true

require 'rails_helper'

describe Tramway::SolidQueue::BulkDestroyJob do
  def create_job(class_name:)
    SolidQueue::Job.create!(
      queue_name: 'default', class_name:, active_job_id: SecureRandom.uuid,
      arguments: { 'executions' => 0, 'exception_executions' => {} }
    )
  end

  before { SolidQueue::Job.destroy_all }

  it 'destroys only the given jobs' do
    selected_job = create_job(class_name: 'SelectedJob')
    other_job = create_job(class_name: 'OtherJob')

    described_class.perform_now([selected_job.id])

    expect(SolidQueue::Job.exists?(selected_job.id)).to be(false)
    expect(SolidQueue::Job.exists?(other_job.id)).to be(true)
  end

  it 'processes the given jobs in batches of 1000' do
    job = create_job(class_name: 'SelectedJob')
    relation = SolidQueue::Job.where(id: job.id)

    allow(SolidQueue::Job).to receive(:where).and_return(relation)
    expect(relation).to receive(:in_batches).with(of: described_class::BATCH_SIZE)

    described_class.perform_now([job.id])
  end
end
