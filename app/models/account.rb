class Account < ApplicationRecord
  CREATE_STAFF_PARAMS = [:full_name, :email,:address,
                         :phone_number,:gender, :image,
                         :password, :password_confirmation,
                         license_attributes: [:major_id, :workspace]]
  UPDATE_STAFF_PARAMS = [:full_name, :email,
                         :address, :phone_number,:gender, :image,
                         license_attributes: [:major_id, :workspace]]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_CARDID_REGEX = /[0-9]{9}/.freeze
  VALID_PHONENUMBER_REGEX = /[0-9]{10}/.freeze

  attr_accessor :remember_token, :activation_token, :reset_token

  has_many :orders, dependent: :destroy
  has_many :received_orders, class_name: Order.name,
    foreign_key: :staff_id
  has_one :license, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :rated_reviews, class_name: Review.name,
    foreign_key: :reviewer_id, dependent: :destroy
  has_one_attached :image

  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.account.email.max_length},
    format: {with: VALID_EMAIL_REGEX}
  validates :full_name, presence: true
  validates :password, presence: true,
    length: {minimum: Settings.account.password.min_length}, allow_nil: true
  validates :card_id, uniqueness: true,
            format: {with: VALID_CARDID_REGEX}, allow_nil: true
  validates :phone_number, uniqueness: true,
    format: {with: VALID_PHONENUMBER_REGEX}
  validates :address, presence: true
  validates :image,
    content_type: {in: %w(image/jpeg image/gif image/png),
      message: I18n.t("activerecord.attributes.account.image_format")},
    size: {less_than: Settings.account.image.max_size.megabytes,
      message: I18n.t("activerecord.attributes.account.image_size")}

  before_save :downcase_email
  before_create :set_default_image
  before_create :set_default_birthday

  scope :by_name, ->(name){where("lower(full_name) LIKE ?", "%#{name.downcase}%")}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  enum role: {customer: 0, admin: 1, staff: 2}
  enum gender: {male: 0, female: 1}
  enum status: {block: 0, unactive: 1, active: 2}

  ransack_alias :account, :full_name_or_email_cont

  accepts_nested_attributes_for :license

  acts_as_paranoid

  def display_image
    image.variant(resize_to_limit: [300, 300])
  end

  private

  def downcase_email
    email.downcase!
  end

  def set_default_image
    return unless image.nil?

    image.attach(io: File.open(Rails.root.join("app", "assets", "images",
                                               "gallery", "team1.png")),
      filename: "team1.png", content_type: "image/png")
  end

  def set_default_birthday
    self.date_of_birth ||= Time.now
  end
end
