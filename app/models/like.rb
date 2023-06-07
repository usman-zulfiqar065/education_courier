class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  scope :created_today, -> { where('Date(created_at) = ?', Time.zone.today) }

  def self.dashboard_status(user, likeable_type)
    if user.admin?
      all.where(likeable_type:)
    elsif likeable_type == 'Blog'
      where(likeable_type:, likeable_id: user.blogs.ids)
    else
      where(likeable_type:, likeable_id: user.comments.ids)
    end
  end
end
