class AddLikesCountToPictures < ActiveRecord::Migration[5.0]
  def self.up
    add_column :pictures, :likes_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :pictures, :likes_count
  end
end
