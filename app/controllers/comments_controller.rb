class CommentsController < ApplicationController
  
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.user_id = current_user.id
    @post = @comment.post
    if @comment.save
      flash[:success] = "Add a comment"
      @post.create_notification_comment(current_user, @comment.id)
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = "This commnt isn't saved."
      redirect_back(fallback_location: root_path)
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:content, :post_id)
    end
  
end
