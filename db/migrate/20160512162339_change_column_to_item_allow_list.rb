class ChangeColumnToItemAllowList < ActiveRecord::Migration[4.2]
  def up
    add_index :rental_item_allow_lists, [:rental_item_id, :group_category_id], \
    unique: true, name: 'index_rental_item_allow_unique'  # 64文字以下にする
  end

  def down
    remove_index :rental_item_allow_lists, [:rental_item_id, :group_category_id]
  end
end
