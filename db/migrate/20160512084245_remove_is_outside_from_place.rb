class RemoveIsOutsideFromPlace < ActiveRecord::Migration[4.2]
  def change
    remove_column :places, :is_outside, :boolean
  end
end
