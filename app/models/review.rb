class Review < ApplicationRecord
  belongs_to :reviewable, polymorphic: true
  belongs_to :account, class_name: Account.name,
    foreign_key: :reviewer_id

  scope :newest_first, ->{order created_at: :desc}
end
