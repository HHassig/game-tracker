class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  followability
  has_one_attached :photo

  def unfollow(user)
    followerable_relationships.where(followable_id: user.id).destroy_all
  end
end
