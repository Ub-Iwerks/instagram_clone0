class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  default_scope -> {order(created_at: :desc)}
  validates :user_id, presence: true
  validates :content, length: {maximum: 140}
  validates :image, content_type: {in: %w[image/jpeg image/png], message: "must be valid image format"},
                    size: {less_than: 5.megabytes, message: "should be less than 5MB"}
  validate :image_presence
  
  def image_presence
    unless image.attached?
      errors.add(:image, 'select is must') #このバリデーションはDBレベルでエラーを感知するのだろうか。'Please select the image'がいい。
    end
  end
  
  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(gravity: :center, resize:"500x500^", crop:"500x500+0+0").processed
  end

end
