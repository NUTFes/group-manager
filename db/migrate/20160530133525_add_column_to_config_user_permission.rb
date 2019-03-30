class AddColumnToConfigUserPermission < ActiveRecord::Migration[4.2]
  def change
    add_column :config_user_permissions, :panel_partial, :string, null: false
  end
end
