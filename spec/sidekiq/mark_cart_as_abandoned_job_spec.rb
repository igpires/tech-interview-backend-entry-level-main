require 'rails_helper'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  it 'enqueues the job' do
    expect {
      described_class.perform_async
    }.to change(described_class.jobs, :size).by(1)
  end
end
