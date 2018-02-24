class UserAddRoleColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :integer, null: false, default: 1
  end
end