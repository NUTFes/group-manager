class RemoveFirstQuestionFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :first_question, :string
  end
end
