class RemoveColumnToShop < ActiveRecord::Migration[4.2]
  def change
    remove_column :shops, :closed, :string
  end
end
