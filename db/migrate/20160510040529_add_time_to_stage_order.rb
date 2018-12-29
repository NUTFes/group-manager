class AddTimeToStageOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :stage_orders, :time_point_start, :string
    add_column :stage_orders, :time_point_end, :string
  end
end
