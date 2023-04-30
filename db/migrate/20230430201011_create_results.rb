class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.integer :user
      t.integer :score
      t.integer :game
      t.text :guess
      t.text :edition
      t.text :display_score

      t.timestamps
    end
  end
end
