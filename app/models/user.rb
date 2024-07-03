class User < ApplicationRecord
  acts_as_token_authenticatable
  has_many :user_sources
  has_many :sources, through: :user_sources
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_sources
  has_many :sources, through: :user_sources
  has_many :comments
  has_many_attached :images
end
