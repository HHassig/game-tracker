class Game < ApplicationRecord
  followability

  def unfollow(game)
    followerable_relationships.where(followable_id: game.id).destroy_all
  end
end
