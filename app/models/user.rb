class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255}, format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  has_secure_password
  validates :password, presence: true, length: {minimum: 6}, allow_nil: true
  validates :username, presence: true, length: {maximum: 50}
  validates :introduction, length: {maximum: 150}
  VALID_TEL_REGEX = /\A\d{10}$|^\d{11}|^$\z/
  validates :tel, format: {with: VALID_TEL_REGEX}
  enum gender: {
    female: 0,
    male: 1,
    unanswered: 2
  }
  has_many :liked_posts, through: :likes, source: :post
  has_many :active_notifications,  class_name: "Notification", foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy
  
  #渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end
  
  #フォローする
  def follow(other_user)
    following << other_user
  end
  #フォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  #フォロー確認する
  def following?(other_user)
    following.include?(other_user)
  end
  
  #いいねする
  def liked(post)
    liked_posts << post
  end
  #いいねする
  def unliked(post)
    Like.find_by(post_id: post.id).destroy
  end
  #いいね済みかどうか確認する
  def liking?(post)
    self.liked_posts.include?(post)
  end
  
  #フォローされた際に、通知インスタンスを作成するメソッド
  def create_notification_follow(current_user)
    #既にフォローされているか、検索/代入
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ?", current_user.id, id, "follow"])
    #既にフォローされていない場合のみ以下を実行
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: "follow"
        )
      notification.save if notification.valid?
    end
  end
  
end