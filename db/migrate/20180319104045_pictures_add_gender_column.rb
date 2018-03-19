class PicturesAddGenderColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :gender, :integer, index: true, null: false
  end
end
