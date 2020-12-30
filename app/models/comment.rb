class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  validates :content, presence: true, length: {maximum: 140}
  validates :user_id, presence: true
  validates :post_id, presence: true
  
  has_many :notifications, class_name: "Notification", foreign_key: "comment_id", dependent: :destroy
  
end
