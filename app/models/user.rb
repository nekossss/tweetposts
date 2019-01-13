class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  
  has_many :tweetposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :likerelationships
  has_many :likings, through: :likerelationships, source: :tweetpost
  
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_tweetposts
    Tweetpost.where(user_id: self.following_ids + [self.id])
  end
  
  
  def like(tweetpost)
    self.likerelationships.find_or_create_by(tweetpost_id: tweetpost.id)
  end

  def unlike(tweetpost)
    likerelationship = self.likerelationships.find_by(tweetpost_id: tweetpost.id)
    likerelationship.destroy if likerelationship
  end

  def liking?(tweetpost)
    self.likings.include?(tweetpost)
  end

  
end