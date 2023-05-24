class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  scope :created_today, -> { where('Date(created_at) = ?', Time.zone.today) }
end
