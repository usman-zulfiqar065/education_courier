class Category < ApplicationRecord
  validates :name, presence: true

  has_many :blogs, dependent: :restrict_with_exception
end
