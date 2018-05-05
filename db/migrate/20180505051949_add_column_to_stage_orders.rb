class AddColumnToStageOrders < ActiveRecord::Migration
  def change
    # 削除
    remove_column :stage_orders, :time_interval, :string
    remove_column :stage_orders, :time_point_start, :string
    remove_column :stage_orders, :time_point_end, :string

    # 追加
    add_column :stage_orders, :use_time_interval, :string, default: ""
    add_column :stage_orders, :prepare_time_interval, :string, default: ""
    add_column :stage_orders, :cleanup_time_interval, :string, default: ""

    add_column :stage_orders, :prepare_start_time, :string, default: ""
    add_column :stage_orders, :performance_start_time, :string, default: ""
    add_column :stage_orders, :performance_end_time, :string, default: ""
    add_column :stage_orders, :cleanup_end_time, :string, default: ""
  end
end
