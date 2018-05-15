class AddColumnPowerOrders < ActiveRecord::Migration
  def change
    add_column :power_orders, :item_url, :string
  end
end
