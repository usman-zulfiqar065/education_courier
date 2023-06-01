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
    member: 2,
    creator: 3,
    admin: 4
  }.freeze

  enum role: ROLES

  has_one_attached :avatar
  has_many :comments, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :likes, dependent: :destroy

  scope :active, -> { where.not(confirmed_at: nil) }

  def liked(likeable_id, likeable_type)
    likes.where(likeable_id:, likeable_type:).exists?
  end

  def user_avatar
    avatar.attached? ? avatar : 'user_avatar.png'
  end
end
