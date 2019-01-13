class Likerelationship < ApplicationRecord
  belongs_to :user
  belongs_to :tweetpost
end
