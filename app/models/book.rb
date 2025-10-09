class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(method, word)
    case method
    when "perfect_match" # 完全一致
      Book.where("title LIKE ?", "#{word}")
    when "forward_match" # 前方一致
      Book.where("title LIKE ?", "#{word}%")
    when "backward_match" # 後方一致
      Book.where("title LIKE ?", "%#{word}")
    when "partial_match" # 部分一致
      Book.where("title LIKE ?", "%#{word}%")
    else
      Book.all
    end
  end
end
