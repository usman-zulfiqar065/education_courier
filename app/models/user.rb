class User < ApplicationRecord
  default_scope { order(:created_at) }
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP } 

  ROLES = {
    subscriber: 0,
    commenter: 1,
    admin:  2
  }.freeze

  enum role: ROLES

  has_many :comments, dependent: :destroy
end
