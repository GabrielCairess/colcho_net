class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :user
      t.references :room
      t.integer :points

      t.timestamps
    end
  end
end
