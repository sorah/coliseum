class JudgeWorker
  include Sidekiq::Worker

  def perform(submission_id)
    retries = 0
    begin
      submission = Submission.find(submission_id.to_i)
    rescue ActiveRecord::RecordNotFound
      return nil if 5 < retries 
      retries += 1
      p "Retried #{submission_id} (#{retries})"
      retry
    end

    submission.judge!
  end
end
