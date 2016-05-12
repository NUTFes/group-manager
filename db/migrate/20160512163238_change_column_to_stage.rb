class ChangeColumnToStage < ActiveRecord::Migration
  def up
    remove_column :stages, :is_sunny,     :boolean
    add_column    :stages, :enable_sunny, :boolean
    add_column    :stages, :enable_rainy, :boolean
    add_column    :stages, :enable,       :boolean
  end

  def down
    add_column    :stages, :is_sunny,     :boolean
    remove_column :stages, :enable_sunny, :boolean
    remove_column :stages, :enable_rainy, :boolean
    remove_column :stages, :enable,       :boolean
  end
end
