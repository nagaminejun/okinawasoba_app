class PostsController < ApplicationController
  before_action :set_user, only:[:create, :new, :edit, :update, :destroy]
  before_action :correct_user
  
  def new
    #debugger
    @post = Post.new
  end
  
  def create
    @post = @user.posts.new(post_params) # 画像表示にかなりてこずった！メモ
    if @post.save
      #debugger
      if @post.image.present?
        @post.image = "/post_#{@post.id}.png"
        File.binwrite("public/#{@post.image}", post_params[:image].read)
        #debugger
      #else
        #debugger
        #@post.image = "/default.png"
      end
        flash[:success] = "新規投稿をしました。"
        redirect_to posts_index_url
        #debugger
      @post.save
    else
      render :new
    end
  end
  
  def index
    #debugger
    @posts = Post.all.order(created_at: :desc)
    #@user = User.find(params[:id])
  end
  
  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    #debugger
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      if post_params[:image]
        @post.image = "/post_#{@post.id}.png"
        File.binwrite("public/#{@post.image}", post_params[:image].read)
      end
      flash[:success] = "投稿を編集しました"
      redirect_to user_post_path
    else
      render :edit
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:success] = "投稿を削除しました。"
    redirect_to @user
  end
  
  private
  
    def set_user
      @user = User.find(params[:user_id])
    end
    
    def post_params
      params.require(:post).permit(:store_name, :menu, :price, :comment, :image)
    end
  
end
