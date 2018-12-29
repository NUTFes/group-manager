class ChangeDayToFesDate < ActiveRecord::Migration[4.2]
  def change
    change_column_null :fes_dates, :day, false
  end
end
