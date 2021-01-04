class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :following, :followers, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcom to Instagram_clone App!!"
      redirect_to @user
    else
      render "new"
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:danger] = "Goodbye!"
    redirect_to root_url
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success]="Profile update!"
      redirect_to @user
    else
      render "edit"
    end
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render "show_follow"
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render "show_follow"
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :username, :website, :introduction, :tel, :gender)
    end
  
end
