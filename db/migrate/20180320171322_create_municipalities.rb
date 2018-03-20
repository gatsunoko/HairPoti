class CreateMunicipalities < ActiveRecord::Migration[5.0]
  def change
    create_table :municipalities do |t|
      t.string :name
      t.integer :order_num
      t.integer :prefecture_id

      t.timestamps
    end
  end
end
