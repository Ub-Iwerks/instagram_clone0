class ApplicationController < ActionController::Base
  include SessionsHelper
  
  private
  #beforeフィルター
  #ログイン済みユーザーかどうか
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger]="Please log in"
      redirect_to login_url
    end
  end
  
  #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  
end
