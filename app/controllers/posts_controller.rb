class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :new, :show]
  before_action :correct_user,   only: :destroy
  
  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:success] = "Post created!!"
      redirect_to @post
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end
  end
  
  def new
    @post = current_user.posts.build
  end
  
  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @comment = current_user.comments.build
    @comments = @post.comments
  end
  
  def destroy
    @post.destroy
    flash[:success] = "Post deleted!"
    redirect_to request.referrer || root_url
  end
  
  private
    def post_params
      params.require(:post).permit(:content, :image)
    end
    
    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
