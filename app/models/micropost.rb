class Micropost < ApplicationRecord
  belongs_to :user

  scope :recent_posts, ->{order created_at: :desc}
  scope :where_user_id, ->(id){where user_id: id}

  has_one_attached :image

  validates :content, presence: true,
            length: {maximum: Settings.user.id.max_length}
  validates :image,
            content_type: {in: %w(image/jpeg image/gif image/png),
                           message: I18n.t("microposts.error.image_format")},
            size: {less_than: Settings.user.image.max_size.megabytes,
                   message: I18n.t("microposts.error.size")}
end
