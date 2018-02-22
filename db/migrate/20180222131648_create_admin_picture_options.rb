class CreateAdminPictureOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :admin_picture_options do |t|
      t.integer :picture_id
      t.string :name
      t.text :profile
      t.string :shop_name
      t.string :shop_address
      t.string :shop_phone_number

      t.timestamps
    end
  end
end
