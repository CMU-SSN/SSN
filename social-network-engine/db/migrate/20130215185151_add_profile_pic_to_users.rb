class AddProfilePicToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile_pic, :string, :default => "profile-pics/default_profile_pic.png"
  end
end
