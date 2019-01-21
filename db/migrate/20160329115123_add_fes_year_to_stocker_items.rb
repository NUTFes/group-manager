class AddFesYearToStockerItems < ActiveRecord::Migration[4.2]
  def change
    add_reference :stocker_items, :fes_year, index: true, foreign_key: true
  end
end
