class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {
    maximum: 30
  }, format: {
    with: VALID_EMAIL_REGEX
  }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :sex, presence: true

  has_secure_password

  has_many :posts, dependent: :destroy

  has_many :active_relationships,
  class_name: "Relationship",
  foreign_key: "follower_id",
  dependent: :destroy

  has_many :passive_relationships,
  class_name: "Relationship",
  foreign_key: "followed_id",
  dependent: :destroy
  #active_relationshipsは中間テーブル
  has_many :following, through: :active_relationships, source: :followed
  #passive_relationshipsは中間テーブル
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :favorites, dependent: :destroy

  has_many :notifications, dependent: :destroy

  mount_uploader :image, ImageUploader



  def self.digest(password)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(password, cost: cost)
  end

  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_attribute(:remember_digest, self.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Post.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def favorite?(post)
    !Favorite.find_by(user_id: id, post_id: post.id).nil?
  end

end
