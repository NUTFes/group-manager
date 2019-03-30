class AddDateOfStoolTestToGroupManagerCommonOption < ActiveRecord::Migration[4.2]
  def change
    add_column :group_manager_common_options, :date_of_stool_test, :string
  end
end
