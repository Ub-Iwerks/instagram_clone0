class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      if @search_posts.nil?
        @feed_items = current_user.feed.paginate(page: params[:page])
      else
        @feed_items = @search_posts.paginate(page: params[:page])
      end
    end
  end
  
  def contact
  end
  
  def about
  end
  
  def terms
  end
end
