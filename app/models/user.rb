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
  
  def get_profile_image(width = 100, height = 100)
    # profile_image が添付されている場合
    if profile_image.attached?
      # Active Storage の variant を使って画像サイズを変更して返す
      profile_image.variant(resize_to_limit: [width, height]).processed
    else
      # 添付されていない場合は代替画像を返す
      'no_image.jpg'
    end
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

  def favorited_by?(book)
    # self.favorites は User モデルと Favorite モデルのアソシエーション（has_many :favorites）を前提としています
    # .where(book_id: book.id) で、その本IDを持つお気に入りが存在するか検索します
    # .exists? は存在すれば true、なければ false を返します
    favorites.exists?(book_id: book.id)
  end
end
