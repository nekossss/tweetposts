class CreateLikerelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :likerelationships do |t|
      t.references :user, foreign_key: true
      t.references :tweetpost, foreign_key: true

      t.timestamps
      t.index [:user_id, :tweetpost_id], unique: true
    end
  end
end
