class AddUidToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :uid, :string
  end
end
