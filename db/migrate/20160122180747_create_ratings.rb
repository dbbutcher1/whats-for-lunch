class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.decimal :rating
      t.integer :times_had, default: 0

      t.belongs_to :user
      t.belongs_to :restaurant

      t.timestamps null: false
    end
  end
end
