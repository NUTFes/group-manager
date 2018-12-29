class AddColumnPowerOrders < ActiveRecord::Migration[4.2]
  def change
    add_column :power_orders, :item_url, :string
  end
end
