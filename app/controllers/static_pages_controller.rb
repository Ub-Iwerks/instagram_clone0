class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @search_feed_items = @search_posts.paginate(page: params[:page])
      #@post = Post.find(params[:id])
      #@comment = current_user.comments.build
    end
  end
  
  def contact
  end
  
  def about
  end
  
  def terms
  end
end
