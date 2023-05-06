class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ edit update destroy ]

  def index
    @comments = Comment.all
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(user: current_user, content: comment_params[:content])
    respond_to do |format|
      if @comment.save
        flash.now[:notice] = 'Thank you for your feedback '
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('feedback_form', partial: "form", locals: { comment: Comment.new }),
            turbo_stream.append('comments', partial: @comment),
            turbo_stream.replace('comments_count', inline: "<%= display_comments_count(@comment.post.comments.count) %>"),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      else
        flash.now[:error] = 'There is a problem getting your feedback '
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("error_messages"),
            turbo_stream.prepend('feedback_form', partial: "shared/error_messages", locals: { object: @comment }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
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
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:content)
    end
end
