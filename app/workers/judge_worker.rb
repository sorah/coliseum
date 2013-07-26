class JudgeWorker
  include Sidekiq::Worker

  def perform(submission_id)
    begin
      submission = Submission.find(submission_id.to_i)
    rescue ActiveRecord::RecordNotFound
      return nil
    end

    submission.judge!
  end
end
