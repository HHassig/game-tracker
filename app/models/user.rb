class User < ApplicationRecord
  after_initialize :set_defaults
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :username, uniqueness: true
  has_one_attached :photo

  private

  def set_defaults
    at_sign = self.email.index("@").to_i - 1
    username = self.email[0..at_sign]
    self.username ||= username[0..9]
  end
end
