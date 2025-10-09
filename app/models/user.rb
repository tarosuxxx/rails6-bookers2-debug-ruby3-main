class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :relationships, source: :followed
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }, allow_blank: true

  def is_followed_by?(user)
    reverse_of_relationships.exists?(follower_id: user.id)
  end

  def following?(other_user)
    followings.include?(other_user)
  end
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def self.looks(method, word)
    case method
    when "perfect_match" # 完全一致
      User.where("name LIKE ?", "#{word}")
    when "forward_match" # 前方一致
      User.where("name LIKE ?", "#{word}%")
    when "backward_match" # 後方一致
      User.where("name LIKE ?", "%#{word}")
    when "partial_match" # 部分一致
      User.where("name LIKE ?", "%#{word}%")
    else
      # 該当しない場合は全てのユーザーを返すなど、適切な処理を記述
      User.all
    end
  end
end
