class AdminPictureOptionDelete < ActiveRecord::Migration[5.0]
  def change
    drop_table :admin_picture_options
  end
end
