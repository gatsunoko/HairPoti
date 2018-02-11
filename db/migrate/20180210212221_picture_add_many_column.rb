class PictureAddManyColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :picture_url, :text, null: false
    add_column :pictures, :shop_name, :string
    add_column :pictures, :shop_name_kana, :string
    add_column :pictures, :shop_address, :string, index: true
    add_column :pictures, :stylist_name, :string
    add_column :pictures, :stylist_profile, :text
    add_column :pictures, :length, :string, index: true
    add_column :pictures, :color, :string, index: true
    add_column :pictures, :image, :string, index: true
  end
end
