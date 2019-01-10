class ToppagesController < ApplicationController
  def index
    if logged_in?
      @tweetpost = current_user.tweetposts.build  # form_for 用
      @tweetposts = current_user.feed_tweetposts.order('created_at DESC').page(params[:page])
    end
  end
end