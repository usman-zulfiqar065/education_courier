class Post < ApplicationRecord
  validates :title, :content, :summary, :slug, :status, :read_time, presence: true

  STATUSES = {
    general:  0,
    featured: 1,
    archived: 2
  }.freeze

  enum status: STATUSES

  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy

  scope :in_descending_order, -> { order(created_at: :desc) }
  scope :published, -> { where('published_at <= ?', DateTime.now) }
  scope :scheduled, -> { where('published_at > ?', DateTime.now) }
  scope :draft, -> { where(published_at: nil) }

  def published?
    self.published_at.present? && published_at <= DateTime.now
  end

  def draft?
    self.published_at.blank?
  end

  def scheduled?
    self.published_at.present? && self.published_at > DateTime.now
  end

  def parent_comments
    self.comments.where(parent_id: nil)
  end
end
