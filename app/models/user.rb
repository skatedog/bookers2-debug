class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  # 自分をフォローしている人のリスト
  has_many :followers_list, class_name: "Relationship", foreign_key: :followed_id, dependent: :destroy
  # 自分をフォローしている人のリストからフォローしている人を取得
  has_many :followers, through: :followers_list, source: :follower

  # 自分がフォローしている人のリスト
  has_many :followeds_list, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  # 自分がフォローしている人のリストからフォローされている人を取得
  has_many :followeds, through: :followeds_list, source: :followed

  attachment :profile_image, destroy: false

  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}

  def followed_by?(user)
    followers.where(id: user.id).exists?
  end
end
