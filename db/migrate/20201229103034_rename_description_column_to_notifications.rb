class RenameDescriptionColumnToNotifications < ActiveRecord::Migration[6.0]
  def change
    rename_column :notifications, :like_id, :comment_id
  end
end
