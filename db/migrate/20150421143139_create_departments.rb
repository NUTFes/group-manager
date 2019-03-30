class CreateDepartments < ActiveRecord::Migration[4.2]
  def change
    create_table :departments do |t|
      t.string :name_ja
      t.string :name_en

      t.timestamps null: false
    end
  end
end
