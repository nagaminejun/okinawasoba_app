module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id # session[:user_id] に user.id を代入という意味
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
    
  
  def current_user
    if session[:user_id]
      if @current_user.nil?
        @current_user = User.find_by(id: session[:user_id]) 
      else
        @current_user
      end
    end
    # Rails推奨の記述は→ @current_user = @current_user || User.find_by(id: session[:user_id]) 10~14が１行で済む
  end
  
  def logged_in?
    !current_user.nil?
  end
end
