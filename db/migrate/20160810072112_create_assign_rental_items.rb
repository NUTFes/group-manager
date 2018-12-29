class CreateAssignRentalItems < ActiveRecord::Migration[4.2]
  def change
    create_table :assign_rental_items do |t|
      t.references :rental_order, index: true, foreign_key: true, null: false
      t.references :rentable_item, index: true, foreign_key: true, null: false
      t.integer :num, null: false

      t.timestamps null: false
    end
  end
end
