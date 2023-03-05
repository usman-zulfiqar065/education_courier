class Post < ApplicationRecord
  default_scope { order(:created_at) }
  validates :title, :summary, :content, :slug, :status,  presence: true

  STATUSES = {
    drafted:    0,
    published: 1,
    archived:  2
  }.freeze

  enum status: STATUSES

  has_many :comments, dependent: :destroy

  def persisted_comments
    comments.where.not(id: nil)
  end

end
