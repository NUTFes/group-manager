class RemoveFesYearFromStockerItems < ActiveRecord::Migration[4.2]
  def up
    remove_column :stocker_items, :fes_year_id, :integer
  end

  def down
    add_column :stocker_items, :fes_year_id, :integer
  end
end
