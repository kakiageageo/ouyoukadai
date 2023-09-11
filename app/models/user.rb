class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_one_attached :profile_image
  
  has_many :followers, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followeds, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  has_many :follow_siteru, through: :followers, source: :followed
  has_many :follow_sareteru, through: :followeds, source: :follower

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}
  
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  def follow(user_id)
    followers.create(followed_id: user_id)
  end
  
  def unfollow(user_id)
    followers.find_by(followed_id: user_id).destroy
  end
  
  def follow_siteru?(user)
    follow_siteru.include?(user)
  end
  
  def self.search_for(content, method)
    if method == "perfect_match"
      @user = User.where("name LIKE?", "#{content}")
    elsif method == "forward_match"
      @user = User.where("name LIKE?","#{content}%")
    elsif method == "backward_match"
      @user = User.where("name LIKE?","%#{content}")
    else
      @user = User.where("name LIKE?","%#{content}%")
    end
  end
  
end
