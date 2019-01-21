class AddDayColumnToFesDate < ActiveRecord::Migration[5.2]
  def change
    add_column :fes_dates, :day, :string
  end
end
