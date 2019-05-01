class AddOrderDeadlineToGroupManagerCommonOptions < ActiveRecord::Migration[5.2]
  def change
    add_column :group_manager_common_options, :order_deadline, :string
  end
end
