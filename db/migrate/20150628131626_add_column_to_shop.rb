class AddColumnToShop < ActiveRecord::Migration[4.2]
  def change
    add_column :shops, :kana, :string
    add_column :shops, :closed, :string
  end
end
