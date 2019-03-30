class CreatePlaces < ActiveRecord::Migration[4.2]
  def change
    create_table :places do |t|
      t.string :name_ja
      t.string :name_en
      t.boolean :is_outside

      t.timestamps null: false
    end
  end
end
