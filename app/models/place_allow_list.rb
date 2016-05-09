class PlaceAllowList < ActiveRecord::Base
  belongs_to :place_id
  belongs_to :group_category_id
end
