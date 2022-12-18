class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @users = User.all
  end
  
  def new
    @user = User.new
  end
  
  def show
    #@user = User.find(params[:id])
    @posts = Post.where(user_id: @user.id)
    #@post = Post.find(params[:id])
  end
  
  def create ##User
    @user = User.new(user_params)
    #debugger
    if @user.save
      #@user.update_attributes(line_user_id: @line_user_id)
      log_in @user # 保存成功後、ログインします。
      #debugger
      if @user.line_user_id.present?
        flash[:success] = 'Lineログインで新規作成しました。'
        redirect_to @user 
        #session.delete(:line_user_id)
      else
        flash[:success] = '新規作成に成功しました。'
        redirect_to @user
      end
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました"
      redirect_to @user
    else
      render :edit
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :line_user_id)
    end
    
    # beforeフィルター
    
    # paramsハッシュからユーザーを取得します。
    def set_user
      @user = User.find(params[:id])
    end

    # ログイン済みのユーザーか確認します。
    def logged_in_user
      unless logged_in?
        store_location # アクセスしようとしたURLを記憶します。
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
     # アクセスしたユーザーが現在ログインしているユーザーか確認します。
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
