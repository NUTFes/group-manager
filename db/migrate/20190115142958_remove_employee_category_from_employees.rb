class RemoveEmployeeCategoryFromEmployees < ActiveRecord::Migration[5.2]
  def change
    remove_column :employees, :employee_category_id, :integer
  end
end
