class Source < ApplicationRecord
  has_many :lumps
  has_many :comments
  has_many :games
  has_many :urls
  has_many :user_sources
  has_many :users, through: :user_sources
  validates :username, presence: true, uniqueness: {case_sensitive: false },
  length: {minimum: 3, maximum:25}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
end
