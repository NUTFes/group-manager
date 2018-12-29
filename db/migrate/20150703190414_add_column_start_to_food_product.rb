class AddColumnStartToFoodProduct < ActiveRecord::Migration[4.2]
  def change
    add_column :food_products, :start, :string
  end
end
