class Grade < ActiveRecord::Base
  def to_s
    self.name
  end
end
