class CreateInsideOrOutsides < ActiveRecord::Migration[5.2]
  def change
    create_table :inside_or_outsides do |t|
      t.string :name

      t.timestamps
    end
  end
end
