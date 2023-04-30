class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.text :name
      t.text :url
      t.integer :user

      t.timestamps
    end
  end
end
