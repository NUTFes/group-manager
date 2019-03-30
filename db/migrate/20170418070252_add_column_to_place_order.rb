class AddColumnToPlaceOrder < ActiveRecord::Migration[4.2]
  def change
    add_column :place_orders, :remark, :text
  end
end
