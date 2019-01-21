class RenameTimeToStageOrder < ActiveRecord::Migration[4.2]
  def change
    rename_column :stage_orders, :time, :time_interval
  end
end
