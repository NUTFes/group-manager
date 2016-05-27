class AddColumnToGroup < ActiveRecord::Migration
  def change
    add_column    :groups, :project_name, :string, defalut: "未回答"
  end
end
