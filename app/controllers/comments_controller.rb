class CommentsController < ApplicationController
  include CommentsConcern
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: %i[index new guest_user_feedback]
  before_action :set_comment, only: %i[edit update destroy]
  before_action :set_blog, only: %i[index new create]
  before_action :set_parent, only: %i[index new create]

  def index
    @comments = if params[:parent_id].present?
                  Comment.find(params[:parent_id]).children
                else
                  @blog.comments
                end
  end

  def new
    @comment = Comment.new
  end

  def create
    params[:parent_id].present? ? create_child_comment : create_comment
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      flash.now[:notice] = 'Comment Updated Successfully'
      handle_successful_comment_update
    else
      flash.now[:error] = 'Unable to update Comment'
      handle_failed_comment_update
    end
  end

  def destroy
    @comment.destroy
    flash.now[:notice] = 'Comment deleted successfully'
    handle_successful_comment_destroy
  rescue StandardError
    flash.now[:error] = 'Unable to delete comment'
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: 'shared/toast') }
    end
  end

  def guest_user_feedback
    if validate_feedback_params
      UserMailer.guest_user_feedback(params[:name], params[:email], params[:feedback]).deliver_later
      handle_successful_guest_feedback
    else
      handle_failed_guest_feedback
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_parent
    @parent = Comment.find(params[:parent_id]) if params[:parent_id].present?
  end

  def set_blog
    @blog = Blog.friendly.find(params[:blog_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def validate_feedback_params
    params[:name].present? && params[:email].present? && params[:feedback].present?
  end
end
