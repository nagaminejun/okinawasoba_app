class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      # チェックボックスの値を評価します。
      if params[:session][:remember_me] == "1"
        remember(user) # オンの時はユーザー情報を記憶します。
      else
        forget(user) # オフの場合は記憶しません。redirect_to user
      end
      # 10~15は三項演算子にすると下記の１行になる
      # params[:session][:remember_me] == '1' ? remember(user) : forget(user) 構造は以下
      # [条件式] ? [真（true）の場合実行される処理] : [偽（false）の場合実行される処理]
      flash[:success] = "ログインしました"
      redirect_to user
    else
      flash.now[:danger] = "認証に失敗しました"
      render :new
    end
  end
  
  def destroy
    # ログイン中の場合のみログアウト処理を実行します。
    log_out if logged_in?
    flash[:success] = "ログアウトしました"
    redirect_to root_url
  end
end
