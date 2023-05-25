class CommentsController < ApplicationController
  include CommentsHelper
  skip_before_action :authenticate_user!, only: %i[index new]
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
end
