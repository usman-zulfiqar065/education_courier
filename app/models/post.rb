class Post < ApplicationRecord
  validates :title, :summary, :content, :slug, :status, :read_time,   presence: true

  STATUSES = {
    general:  0,
    featured: 1,
    archived: 2
  }.freeze

  enum status: STATUSES

  has_many :comments, dependent: :destroy

  default_scope { order(:created_at) }
  scope :published, -> { where('published_at <= ?', DateTime.now) }
  scope :scheduled, -> { where('published_at > ?', DateTime.now) }
  scope :draft, -> { where(published_at: nil) }

  def persisted_comments
    comments.where.not(id: nil)
  end

end
