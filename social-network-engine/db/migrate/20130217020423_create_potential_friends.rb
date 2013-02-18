class CreatePotentialFriends < ActiveRecord::Migration
  def change
    create_table :potential_friends do |t|
      t.integer :user_id
      t.string :friend_facebook_id

      t.timestamps
    end
  end
end
