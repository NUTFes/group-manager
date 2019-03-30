class CreateFesYears < ActiveRecord::Migration[4.2]
  def change
    create_table :fes_years do |t|
      t.integer :fes_year, null: false

      t.timestamps null: false
    end
  end
end
