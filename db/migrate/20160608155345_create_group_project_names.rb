class CreateGroupProjectNames < ActiveRecord::Migration[4.2]
  def change
    create_table :group_project_names do |t|
      t.references :group, index: true, foreign_key: true
      t.string :project_name, unique:true, null:false

      t.timestamps null: false
    end
  end
end
