class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_one_attached :image
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, length: {maximum: 140}
  validates :image, content_type: {in: %w[image/jpeg image/png], message: "must be valid image format"},
                    size: {less_than: 5.megabytes, message: "should be less than 5MB"}
  #validate :image_presence
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, class_name: "Notification", foreign_key: "post_id", dependent: :destroy

  
  #このバリデーションはDBレベルでエラーを感知できない。→seedファイルを実行する際にエラーが生じてしまう(DBに画像ファイルを登録できてない為)。
  #エラーメッセージの設定 'Please select the image'がいい。
  def image_presence
    unless image.attached?
      errors.add(:image, 'select is must')
    end
  end
  
  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(gravity: :center, resize:"500x500^", crop:"500x500+0+0").processed
  end
  
  
  #いいねされた際に、通知インスタンスを作成するメソッド
  def create_notification_like(current_user)
    #既にいいねされているか、検索/代入
    temp = Notification.where(["visitor_id = ? and visited_id = ? and post_id = ? and action = ?", current_user.id, user_id, id, "like"])
    #既にいいねされていない場合のみ以下を実行
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: user_id,
        post_id: id,
        action: "like"
        )
      #自分の投稿へのいいねの場合、check済みにする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
  
  
  #自分以外にコメントしている人をすべて取得し、全員に通知を送るメソッド
  def create_notification_comment(current_user, comment_id)
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_user, comment_id, temp_id["user_id"])
    end
  #まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment(current_user, comment_id, user_id) if temp_ids.blank?
  end
  
  #コメントされた際に、通知インスタンスを作成
  def save_notification_comment(current_user, comment_id, visited_id)
  #コメントさているかどうかの有無に関わらず、インスタンスを作成
    notification = current_user.active_notifications.new(
      post_id: id,
      comment_id: comment_id,
      visited_id: user_id,
      action: "comment"
      )
  #自分の投稿へのコメントの場合、check済みにする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  

end
