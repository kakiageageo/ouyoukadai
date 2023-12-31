class Book < ApplicationRecord
  belongs_to :user
  has_many   :favorites, dependent: :destroy
  has_many   :book_comments, dependent: :destroy
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def self.search_for(content, method)
    if method == "perfect_match"
      @book = Book.where("title LIKE?","#{content}")
    elsif method == "forward_match"
      @book = Book.where("title LIKE?","#{content}%")
    elsif method == "backward_match"
      @book = Book.where("title LIKE?","%#{content}")
    else
      @book = Book.where("title LIKE?","%#{content}%")
    end
  end
  
end
