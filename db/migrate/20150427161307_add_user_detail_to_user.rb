class AddUserDetailToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :user_detail, index: true, foreign_key: true
  end
end
