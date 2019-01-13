class LikerelationshipsController < ApplicationController
  before_action :require_user_logged_in

  def create
    tweetpost = Tweetpost.find(params[:tweetpost_id])
    current_user.like(tweetpost)
    flash[:success] = '投稿をお気に入りしました。'
    redirect_back(fallback_location: root_url)
  end

  def destroy
    tweetpost = Tweetpost.find(params[:tweetpost_id])
    current_user.unlike(tweetpost)
    flash[:success] = 'お気に入りを解除しました。'
    redirect_back(fallback_location: root_url)
  end
end
