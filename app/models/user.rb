class User < ActiveRecord::Base
  has_many :problems
  has_many :submissions

  def staff?() self.staff end
  def shown_name() self.name || self.nick end

  def promote!
    self.update_attributes!(staff: true)
  end

  def demote!
    self.update_attributes!(staff: false)
  end
end
