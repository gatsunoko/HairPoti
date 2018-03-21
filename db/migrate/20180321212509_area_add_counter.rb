class AreaAddCounter < ActiveRecord::Migration[5.0]
  def change
    add_column :prefectures, :pictures_count, :integer, default: 0
    add_column :municipalities, :pictures_count, :integer, default: 0
  end
end
