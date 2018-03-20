class CreateStylists < ActiveRecord::Migration[5.0]
  def change
    create_table :stylists do |t|
      t.integer :user_id
      t.string :shop_name
      t.string :shop_address, index: true
      t.string :shop_phone_number

      t.timestamps
    end
  end
end
