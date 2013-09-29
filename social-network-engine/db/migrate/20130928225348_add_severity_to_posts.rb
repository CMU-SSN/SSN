class AddSeverityToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :severity, :integer
  end
end
