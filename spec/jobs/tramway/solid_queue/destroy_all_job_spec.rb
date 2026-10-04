# frozen_string_literal: true

require 'rails_helper'

describe Tramway::SolidQueue::DestroyAllJob do
  def create_job(class_name:, queue_name: 'default')
    SolidQueue::Job.create!(
      queue_name:, class_name:, active_job_id: SecureRandom.uuid,
      arguments: { 'executions' => 0, 'exception_executions' => {} }
    )
  end

  before { SolidQueue::Job.destroy_all }

  it 'destroys every job when no filters are given' do
    first_job = create_job(class_name: 'FirstJob')
    second_job = create_job(class_name: 'SecondJob')

    described_class.perform_now

    expect(SolidQueue::Job.exists?(first_job.id)).to be(false)
    expect(SolidQueue::Job.exists?(second_job.id)).to be(false)
  end

  it 'destroys only the jobs matching the given filters' do
    matching_job = create_job(class_name: 'MatchingJob', queue_name: 'mailers')
    other_job = create_job(class_name: 'OtherJob', queue_name: 'default')

    described_class.perform_now({ 'queue_name' => 'mailers' })

    expect(SolidQueue::Job.exists?(matching_job.id)).to be(false)
    expect(SolidQueue::Job.exists?(other_job.id)).to be(true)
  end

  it 'processes the matching jobs in batches of 1000' do
    create_job(class_name: 'FirstJob')
    relation = SolidQueue::Job.all

    filter = instance_double(Tramway::SolidQueue::JobsFilter, jobs: relation)
    allow(Tramway::SolidQueue::JobsFilter).to receive(:new).and_return(filter)
    expect(relation).to receive(:in_batches).with(of: described_class::BATCH_SIZE)

    described_class.perform_now
  end
end
