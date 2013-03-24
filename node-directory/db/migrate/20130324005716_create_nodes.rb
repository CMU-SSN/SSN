class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :city
      t.string :zipcode

      t.timestamps
    end
  end
end
