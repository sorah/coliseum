require 'judge'

class Submission < ActiveRecord::Base
  REDIS_CHANNEL = 'coliseum:submission'

  belongs_to :user
  belongs_to :problem

  serialize :judge_result, Array

  paginates_per 10

  class << self
    def stream
      Redis.current.subscribe(REDIS_CHANNEL) do |on|
        on.message do |ch, id|
          begin
            submission = Submission.find(id)
          rescue ActiveRecord::RecordNotFound
            next
          end

          yield submission
        end
      end
    end
  end

  def kick_judge
    announce
    JudgeWorker.perform_async(self.id)
  end
  after_create :kick_judge

  def judge_status
    attributes["judge_status"].try(&:to_sym) || :pending
  end

  def judge!
    self.judge_status = :judging
    self.judge_result = nil
    self.save!

    announce

    self.judge_result = self.problem.test_examples.map do |test_example|
      Judge.new(test_example).test(self.code)
    end

    self.judge_status = if self.judge_result.all? { |judge| judge[:result] == :success }
                          :success
                        else
                          :failed
                        end
    self.save!

    announce

    self
  end

  private

  def announce
    Redis.current.publish(REDIS_CHANNEL, self.id.to_s)
  end
end
