class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  default_scope { order(:created_at) }
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  ROLES = {
    member: 0,
    creator: 1,
    admin: 2,
    owner: 3
  }.freeze

  enum role: ROLES

  has_one_attached :avatar
  has_one :user_summary, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :likes, dependent: :destroy

  accepts_nested_attributes_for :user_summary

  scope :active, -> { where.not(confirmed_at: nil) }
  scope :blogger, -> { joins(:blogs).distinct }

  def liked(likeable_id, likeable_type)
    likes.where(likeable_id:, likeable_type:).exists?
  end

  def user_avatar
    avatar.attached? && avatar || 'user_avatar.png'
  end

  def blogger?
    blogs.exists?
  end

  def blog_comments
    admin? && Comment.all || Comment.all.where(blog_id: blogs.ids).or(comments)
  end

  def blog_likes
    if admin?
      Like.all
    else
      Like.where(likeable_type: 'Blog', likeable_id: blogs.ids)
          .or(Like.where(likeable_type: 'Comment', likeable_id: comments.ids))
    end
  end

  def admin_dashboard_blogs
    admin? && Blog.all || blogs
  end
end
