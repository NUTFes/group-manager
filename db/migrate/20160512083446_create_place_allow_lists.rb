class CreatePlaceAllowLists < ActiveRecord::Migration[4.2]
  def change
    create_table :place_allow_lists do |t|
      t.references :place, index: true, foreign_key: true
      t.references :group_category, index: true, foreign_key: true
      t.boolean :enable

      t.timestamps null: false
    end
  end
end
