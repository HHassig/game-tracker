class AddMaxScoreToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :max_score, :integer
  end
end
