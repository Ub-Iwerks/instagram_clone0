module SessionsHelper
  
  #渡されたユーザーでログインする=sessionメソッドにidを保存する
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #現在ログイン中のユーザーを返す(いる場合に限り)
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  #ログイン中のユーザーがいればtrueを、いなければfalseを
  def logged_in?
    !current_user.nil?
  end
  
  #現在のユーザーをログアウトする
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
end
