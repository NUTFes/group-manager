class RemoveFirstQuestionFromGroups < ActiveRecord::Migration[4.2]
  def change
    remove_column :groups, :first_question, :string
  end
end
