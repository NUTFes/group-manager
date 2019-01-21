class ChangeColumnToStockerPlaces < ActiveRecord::Migration[4.2]
  def change
    change_column :stocker_places, :is_available_fesdate, :boolean, null: false, default: true
  end
end
