class PictureAddCountColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :win, :integer, { null: false, default: 0 }
    add_column :pictures, :lose, :integer, { null: false, default: 0 }
    add_column :user_pictures, :win, :integer, { null: false, default: 0 }
    add_column :user_pictures, :lose, :integer, { null: false, default: 0 }
  end
end