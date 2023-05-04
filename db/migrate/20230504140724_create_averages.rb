class CreateAverages < ActiveRecord::Migration[7.0]
  def change
    create_table :averages do |t|
      t.integer :game
      t.integer :user
      t.float :average

      t.timestamps
    end
  end
end
