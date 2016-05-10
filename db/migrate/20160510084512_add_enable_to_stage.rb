class AddEnableToStage < ActiveRecord::Migration
  def change
    add_column :stages, :enable, :boolean
  end
end
