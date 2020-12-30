class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_search, :set_global_search_variable
  
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
  
  #formから受け取った変数を定義していないとエラーが生じるため
  def set_global_search_variable
    @q = Post.ransack(params[:q])
  end
  
  #formから受け取った値が存在する場合のみ、@search_postsを返す。
  def set_search
    temp = params[:q]
    if !temp.nil?
      @q = Post.ransack(temp)
      @search_posts = @q.result(distinct: true)
    end
  end
  
  #正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  
end
