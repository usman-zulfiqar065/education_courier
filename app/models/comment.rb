class Comment < ApplicationRecord
  validates :content, presence: true

  has_many :children, class_name: 'Comment', foreign_key: :parent_id
  belongs_to :parent, class_name: 'Comment', optional: true
  belongs_to :user
  belongs_to :post
end
