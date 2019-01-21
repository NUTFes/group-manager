class AddFesYearToFesDate < ActiveRecord::Migration[4.2]
  def change
    add_reference :fes_dates, :fes_year, index: true, foreign_key: true
  end
end
