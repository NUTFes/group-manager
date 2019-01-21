class AddColumnToPurchaseList < ActiveRecord::Migration[4.2]
  def change
    add_column :purchase_lists, :items, :string, null: false
  end
end
