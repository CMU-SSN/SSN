class AddLinkToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :link, :string
  end
end
