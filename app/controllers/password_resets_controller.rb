class PasswordResetsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if params[:user][:password].empty? 
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params) 
      log_in @user
      flash[:success] = "Password has been changed."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end
    
end
