class User < ActiveRecord::Base
  def staff?() self.staff end
  def shown_name() self.name || self.nick end
end
