class InsideOrOutside < ActiveRecord::Base
  belongs_to :place_order
  
  def to_s
    self.name
  end
end
