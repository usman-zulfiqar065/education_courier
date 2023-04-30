class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  default_scope { order(:created_at) }
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

  ROLES = {
    blogger: 0,
    subscriber: 1,
    commenter: 2,
    admin:  3
  }.freeze

  enum role: ROLES

  has_many :comments, dependent: :destroy
  has_many :posts, dependent: :destroy
end
