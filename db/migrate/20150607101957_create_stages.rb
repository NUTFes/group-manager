class CreateStages < ActiveRecord::Migration[4.2]
  def change
    create_table :stages do |t|
      t.string :name_ja
      t.string :name_en
      t.boolean :is_sunny

      t.timestamps null: false
    end
  end
end
