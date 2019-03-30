class RemoveCommonOptionToStageOrders < ActiveRecord::Migration[4.2]
  def change
    remove_column :stage_orders, :own_equipment
    remove_column :stage_orders, :bgm
    remove_column :stage_orders, :camera_permittion
    remove_column :stage_orders, :loud_sound
  end
end
