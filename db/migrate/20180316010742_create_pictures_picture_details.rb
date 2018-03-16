class CreatePicturesPictureDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures_picture_details do |t|
      t.string :name
      t.integer :genre
      t.integer :user_id
      t.integer :picture_id

      t.timestamps
    end
  end
end
