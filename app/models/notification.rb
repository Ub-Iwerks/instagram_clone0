class Notification < ApplicationRecord
  default_scope -> {order(created_at: :desc)}
  belongs_to :comment, optional: true
  belongs_to :post, optional: true
  belongs_to :user, class_name: "User", foreign_key: "visitor_id"
  belongs_to :user, class_name: "User", foreign_key: "visited_id"
end
