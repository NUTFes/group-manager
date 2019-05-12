class AddInsideOrOutsideToPlaceOrder < ActiveRecord::Migration[5.2]
  def change
    add_reference :place_orders, :inside_or_outside, foreign_key: true
  end
end
