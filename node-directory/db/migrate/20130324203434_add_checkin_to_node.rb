class AddCheckinToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :checkin, :datetime
  end
end
