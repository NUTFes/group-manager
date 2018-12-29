class CreateGroupManagerCommonOptions < ActiveRecord::Migration[4.2]
  def change
    create_table :group_manager_common_options do |t|
      t.string :cooking_start_time

      t.timestamps null: false
    end
  end
end
