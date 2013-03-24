class AddStateToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :state, :string
  end
end
