class AddFesYearToGroup < ActiveRecord::Migration[4.2]
  def change
    add_reference :groups, :fes_year, index: true, foreign_key: true
  end
end
