class User < ActiveRecord::Base
  has_many :problems
  has_many :submissions

  scope :leaderboard, -> {
    joins('INNER JOIN submissions ON ' \
            'submissions.user_id = users.id ' \
            'AND submissions.judge_status = "success"') \
      .select('*, count(submissions.id) AS success_count') \
      .order('success_count DESC')
  }

  def staff?() self.staff end
  def shown_name() self.name || self.nick end

  def promote!
    self.update_attributes!(staff: true)
  end

  def demote!
    self.update_attributes!(staff: false)
  end
end
