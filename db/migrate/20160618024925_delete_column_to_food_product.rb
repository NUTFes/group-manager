class DeleteColumnToFoodProduct < ActiveRecord::Migration[4.2]
  def up
    remove_column :food_products, :start, :string
  end
  def down
    add_column    :food_products, :start, :string
  end
end
