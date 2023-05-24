class CommentsController < ApplicationController
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

  private

  def create_comment
    @comment = @blog.comments.new(user: current_user, content: comment_params[:content])
    if @comment.save
      UserMailer.notify_user_about_comment(@comment).deliver_later
      flash.now[:notice] = 'Thank you for your feedback'
      handle_comment_creation_success
    else
      flash.now[:error] = 'There is a problem getting your feedback'
      handle_failed_comment_creation
    end
  end

  def handle_comment_creation_success
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('new_comment_form', partial: 'form', locals: { comment: Comment.new, parent: nil }),
          turbo_stream.append('comments', partial: @comment, locals: { blog: @blog }),
          turbo_stream.replace('comments_count',
                               inline: '<%= display_comments_count(@comment.blog.comments.count) %>'),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  end

  def handle_failed_comment_creation
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove('error_messages'),
          turbo_stream.prepend('new_comment_form', partial: 'shared/error_messages', locals: { object: @comment }),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  end

  def create_child_comment
    @comment = @blog.comments.new(user: current_user, content: comment_params[:content], parent: @parent)
    if @comment.save
      generate_mails
      flash.now[:notice] = 'Thank you for your feedback '
      handle_child_comment_creation_success
    else
      flash.now[:error] = 'There is a problem getting your feedback '
      handle_failed_child_comment_creation
    end
  end

  def handle_child_comment_creation_success
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace('comments_count', inline: '<%= display_comments_count(@comment.blog.comments.count) %>'),
          turbo_stream.replace("comment_#{params[:parent_id]}_child_comment", partial: @comment,
                                                                              locals: { blog: @blog }),
          turbo_stream.replace("comment_#{params[:parent_id]}_replies", partial: 'replies',
                                                                        locals: { comment: @parent, blog: @blog }),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  end

  def handle_failed_child_comment_creation
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove('error_messages'),
          turbo_stream.prepend("comment_#{params[:parent_id]}_child_comment", partial: 'shared/error_messages',
                                                                              locals: { object: @comment }),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  end

  def handle_successful_comment_update
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("comment_#{@comment.id}_content", partial: 'comment_content',
                                                                 locals: { comment: @comment, blog: @comment.blog }),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  end

  def handle_failed_comment_update
    format.turbo_stream do
      render turbo_stream: [
        turbo_stream.remove('error_messages'),
        turbo_stream.prepend("comment_#{@comment.id}_content", partial: 'shared/error_messages',
                                                               locals: { object: @comment }),
        turbo_stream.prepend('body_tag', partial: 'shared/toast')
      ]
    end
  end

  def handle_successful_comment_destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(helpers.dom_id(@comment).to_s),
          turbo_stream.replace('comments_count', inline: '<%= display_comments_count(@comment.blog.comments.count) %>'),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  end

  def generate_mails
    UserMailer.notify_user_about_comment(@comment).deliver_later
    UserMailer.notify_user_about_reply(@comment).deliver_later
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_parent
    @parent = Comment.find(params[:parent_id]) if params[:parent_id].present?
  end

  def set_blog
    @blog = Blog.find(params[:blog_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
