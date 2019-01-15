class TweetpostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]

  def create
    @tweetpost = current_user.tweetposts.build(tweetpost_params)
    if @tweetpost.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @tweetposts = current_user.feed_tweetposts.order('created_at DESC').page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render 'toppages/index'
    end
  end

  def destroy
    @tweetpost.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end
  
  
  def show
    @tweetpost = Tweetpost.find(params[:id])
  end  
  
  
  def edit
    @tweetpost = Tweetpost.find(params[:id])
    flash[:success] = 'メッセージを編集しました。'
    redirect_back(fallback_location: root_path)
  end
  
  def update
    @tweetpost = Tweetpost.find(params[:id])

    if @tweetpost.update(tweetpost_params)
      flash[:success] = 'tweetpost は正常に更新されました'
      redirect_to @tweetpost
    else
      flash.now[:danger] = 'tweetpost は更新されませんでした'
      render :edit
    end
  end



  private

  def tweetpost_params
    params.require(:tweetpost).permit(:content)
  end
  
  def correct_user
    @tweetpost = current_user.tweetposts.find_by(id: params[:id])
    unless @tweetpost
      redirect_to root_url
    end
  end
end