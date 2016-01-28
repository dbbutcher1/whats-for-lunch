class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :google_place_id

      t.timestamps null: false
    end
  end
end
