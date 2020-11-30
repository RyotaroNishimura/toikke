class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  default_scope -> { order(created_at: :desc) }

  validates :user_id, presence: true
  validates :content, allow_nil: true, length: { maximum: 140 }
  validates :popularity,
            :numericality => {
              :only_interger => true,
              :greater_than_or_equal_to => 1,
              :less_than_or_equal_to => 5
            },
            allow_nil: true
  validates :title, presence: true
  validates :price, presence: true
  validates :category, presence: true
end
