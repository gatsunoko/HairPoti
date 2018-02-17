class UserAddProfileColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :name, :string
    add_column :users, :profile, :text
    add_column :users, :shop_name, :text
    add_column :users, :shop_address, :string
    add_column :users, :shop_phone_number, :string
  end
end
