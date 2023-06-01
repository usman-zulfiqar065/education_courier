class Category < ApplicationRecord
  validates :name, presence: true

  has_one_attached :avatar
  has_many :blogs, dependent: :restrict_with_exception

  def category_avatar
    avatar.attached? && avatar || 'category_default_avatar.png'
  end
end
