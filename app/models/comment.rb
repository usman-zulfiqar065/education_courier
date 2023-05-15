class Comment < ApplicationRecord
  validates :content, presence: true

  belongs_to :user
  belongs_to :blog
  belongs_to :parent, class_name: 'Comment', optional: true
  has_many :children, class_name: 'Comment', foreign_key: :parent_id, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
end
