class AddVoIpExtToUser < ActiveRecord::Migration
  def change
    add_column :users, :voip_ext, :integer
  end
end
