class CreateUserPictures < ActiveRecord::Migration[5.0]
  def change
    create_table :user_pictures do |t|
      t.integer :user_id, index: true
      t.integer :picture_id
      t.integer :rating, null: false, default: 1500

      t.timestamps
    end
  end
end
