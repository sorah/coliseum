class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :problem

  serialize :judge_result, Array
end
