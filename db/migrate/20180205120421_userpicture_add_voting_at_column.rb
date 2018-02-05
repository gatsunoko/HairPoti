class UserpictureAddVotingAtColumn < ActiveRecord::Migration[5.0]
  def change
    add_column :user_pictures, :voting_at, :datetime
  end
end
