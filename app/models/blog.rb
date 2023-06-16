class Blog < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: %i[slugged history]
  validates :title, :content, :summary, :tags, :status, :read_time, presence: true
  validates :read_time, comparison: { greater_than_or_equal_to: 0.5 }

  STATUSES = {
    general: 0,
    featured: 1,
    archived: 2
  }.freeze

  enum status: STATUSES

  belongs_to :user
  belongs_to :category
  has_one_attached :avatar
  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  scope :in_descending_order, -> { order(created_at: :desc) }
  scope :in_ascending_order, -> { order(created_at: :asc) }
  scope :published, -> { where('published_at <= ?', DateTime.now) }
  scope :scheduled, -> { where('published_at > ?', DateTime.now) }
  scope :created_today, -> { where('Date(created_at) = ?', Time.zone.today) }
  scope :draft, -> { where(published_at: nil) }

  def should_generate_new_friendly_id?
    title_changed?
  end

  def published?
    published_at.present? && published_at <= DateTime.now
  end

  def draft?
    published_at.blank?
  end

  def scheduled?
    published_at.present? && published_at > DateTime.now
  end

  def parent_comments
    comments.where(parent_id: nil)
  end

  def blog_avatar
    avatar.attached? && avatar || 'blog_default_avatar.jpg'
  end
end
