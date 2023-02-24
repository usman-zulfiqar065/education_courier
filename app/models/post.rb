class Post < ApplicationRecord
    validates :title, :summary, :content, :slug, presence: true

    STATUSES = {
      drafted:    0,
      published: 1,
      archived:  2
    }.freeze

    enum status: STATUSES
end
