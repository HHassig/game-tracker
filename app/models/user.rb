class User < ApplicationRecord
  after_initialize :set_defaults
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  followability
  validates :username, uniqueness: true
  has_one_attached :photo

  def unfollow(user)
    followerable_relationships.where(followable_id: user.id).destroy_all
  end

  # def unfollow_game(game)
  #   raise
  #   followerable_relationships.where(followable_id: game.id).destroy_all
  # end

  private

  def set_defaults
    at_sign = self.email.index("@").to_i - 1
    username = self.email[0..at_sign]
    self.username ||= username[0..9]
  end
end
