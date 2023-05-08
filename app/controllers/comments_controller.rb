class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ edit update destroy ]
  before_action :set_post, only: %i[ new create ]

  def index
    @comments = Comment.all
  end

  def new
    @comment = Comment.new
    @parent = Comment.find(params[:parent_id])
  end

  def create
    params[:parent_id].present? ? create_child_comment : create_comment
  end

  def edit; end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        flash.now[:notice] = 'Comment Updated Successfully'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("comment_#{@comment.id}_content", partial: 'comment_content', 
                                                                   locals: { comment: @comment }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      else
        format.turbo_stream do
          flash.now[:error] = 'Unable to update Comment'
          render turbo_stream: [
            turbo_stream.remove("error_messages"),
            turbo_stream.prepend("comment_#{@comment.id}_content", partial: 'shared/error_messages',
                                                                 locals: { object: @comment }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      flash.now[:notice] = 'Comment deleted successfully'
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove(helpers.dom_id(@comment).to_s),
          turbo_stream.replace('comments_count', inline: "<%= display_comments_count(@comment.post.comments.count) %>"),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  rescue StandardError
    flash.now[:error] = 'Unable to delete comment'
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: 'shared/toast') }
    end
  end

  private

  def create_comment
    @comment = @post.comments.new(user: current_user, content: comment_params[:content])
    @comment.parent_id = params[:parent_id] if params[:parent_id].present?
    respond_to do |format|
      if @comment.save
        flash.now[:notice] = 'Thank you for your feedback '
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('new_comment_form', partial: "form", locals: { comment: Comment.new, parent: nil }),
            turbo_stream.append('comments', partial: @comment, locals: { post: @post }),
            turbo_stream.replace('comments_count', inline: "<%= display_comments_count(@comment.post.comments.count) %>"),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      else
        flash.now[:error] = 'There is a problem getting your feedback '
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("error_messages"),
            turbo_stream.prepend('new_comment_form', partial: "shared/error_messages", locals: { object: @comment }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
  end

  def create_child_comment 
    @comment = @post.comments.new(user: current_user, content: comment_params[:content], parent_id: params[:parent_id])
    respond_to do |format|
      if @comment.save
        flash.now[:notice] = 'Thank you for your feedback '
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('comments_count', inline: "<%= display_comments_count(@comment.post.comments.count) %>"),
            turbo_stream.remove("comment_#{params[:parent_id]}_child_comment"),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      else
        flash.now[:error] = 'There is a problem getting your feedback '
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("error_messages"),
            turbo_stream.prepend("comment_#{params[:parent_id]}_child_comment", partial: "shared/error_messages", locals: { object: @comment }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
