require 'judge'

class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem

  serialize :judge_result, Array

  def kick_judge
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

    self.judge_result = self.problem.test_examples.map do |test_example|
      Judge.new(test_example).test(self.code)
    end

    self.judge_status = if self.judge_result.all? { |judge| judge[:result] == :success }
                          :success
                        else
                          :failed
                        end
    self.save!
  end
end
