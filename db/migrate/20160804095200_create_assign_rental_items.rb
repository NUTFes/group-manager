class CreateAssignRentalItems < ActiveRecord::Migration
  def change
    create_table :assign_rental_items do |t|
      t.references :rental_order, index: true, foreign_key: true
      t.references :rentable_item, index: true, foreign_key: true
      t.integer :num

      t.timestamps null: false
    end
  end
end
