class CreateRentalItems < ActiveRecord::Migration[4.2]
  def change
    create_table :rental_items do |t|
      t.string :name_ja, null: false, unique: true
      t.string :name_en

      t.timestamps null: false
    end
  end
end
