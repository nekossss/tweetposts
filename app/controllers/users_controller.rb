class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :followings, :followers, :likings, :destroy, :edit, :update]
  before_action :set_user, only: [:edit, :update]
  
  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tweetposts = @user.tweetposts.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def destroy
    if current_user.admin?
      @user = User.find(params[:id])
      if current_user == @user
        @user.destroy
        flash[:success] = '退会しました。'
        redirect_back(fallback_location: root_path)
      else
        @user.destroy
        flash[:success] = 'ユーザー削除しました。'
        redirect_back(fallback_location: root_path)
      end
    else
      @user = User.find(params[:id])
      if current_user == @user
        @user.destroy
        flash[:success] = '退会しました。'
        redirect_back(fallback_location: root_path)
      end
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end
  
  
  def likes
    @user = User.find(params[:id])
    @tweetposts = @user.likings.page(params[:page])
    counts(@user)
    render :show
  end
  
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報を編集しました。'
      redirect_back(fallback_location: root_path)
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def set_user
    @user = User.find(params[:id])
    unless current_user == @user
      redirect_to user_path(current_user)
    end
  end
end
