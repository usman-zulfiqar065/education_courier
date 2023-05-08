class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :post
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :children, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy

end
