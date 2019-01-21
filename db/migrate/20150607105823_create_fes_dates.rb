class CreateFesDates < ActiveRecord::Migration[4.2]
  def change
    create_table :fes_dates do |t|
      t.integer :days_num
      t.string :date

      t.timestamps null: false
    end
  end
end
