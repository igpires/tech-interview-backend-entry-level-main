class MarkCartAsAbandonedJob
  include Sidekiq::Job

  def perform(*args)
    CartAbandonmentService.call
  end
end
