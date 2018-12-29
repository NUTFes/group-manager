class CreateGroups < ActiveRecord::Migration[4.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false, unique: true
      t.references :group_category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text :activity
      t.text :first_question

      t.timestamps null: false
    end
  end
end
