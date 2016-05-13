class ChangeValidationToStage < ActiveRecord::Migration
  def up
    change_column :stages, :name_ja,      :string , :null=>false
    change_column :stages, :enable_sunny, :boolean, :default=>false
    change_column :stages, :enable_rainy, :boolean, :default=>false
    change_column :stages, :enable      , :boolean, :default=>false
  end

  def down
    change_column :stages, :name_ja,      :string , :null=>true
    change_column :stages, :enable_sunny, :boolean, :default=>nil
    change_column :stages, :enable_rainy, :boolean, :default=>nil
    change_column :stages, :enable      , :boolean, :default=>nil
  end
end
