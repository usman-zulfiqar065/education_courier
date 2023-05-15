class LikesController < ApplicationController
  before_action :set_likeable
  def create
    @like = current_user.likes.new(like_params)
    if @like.save
      @likeable_type == 'Comment' ? comment_like_success : blog_like_success
    else
      like_failure
    end
  end

  def destroy
    @like = current_user.likes.find_by(likeable_type: @likeable_type, likeable_id: @likeable_id)
    @like.destroy
    @likeable_type == 'Comment' ? comment_unlike_success : blog_like_success
  rescue StandardError
    unlike_failure
  end

  private

  def like_params
    params.require(:like).permit(:likeable_id, :likeable_type)
  end

  def set_likeable
    @likeable_id = params.require(:like)[:likeable_id]
    @likeable_type = params.require(:like)[:likeable_type]
    @likeable = @likeable_type.constantize.find(@likeable_id)
  end

  def comment_like_success
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.replace("comment_#{@likeable.id}_content", partial: 'comments/comment_content',
                                                                  locals: { comment: @likeable, blog: @likeable.blog })
      end
    end
  end

  def like_failure
    respond_to do |format|
      flash.now[:error] = 'Unable to add like'
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: 'shared/toast') }
    end
  end

  def comment_unlike_success
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.replace("comment_#{@likeable.id}_content", partial: 'comments/comment_content',
                                                                  locals: { comment: @likeable, blog: @likeable.blog })
      end
    end
  end

  def unlike_failure
    flash.now[:error] = 'Unable to remove like'
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: 'shared/toast') }
    end
  end

  def blog_like_success
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.replace('blog_react_btns', partial: 'blogs/blog_react_btns', locals: { blog: @likeable })
      end
    end
  end
end
