class CreateRentalOrders < ActiveRecord::Migration[4.2]
  def change
    create_table :rental_orders do |t|
      t.references :group, index: true, foreign_key: true
      t.references :rental_item, index: true, foreign_key: true
      t.integer :num

      t.timestamps null: false
    end
  end
end
