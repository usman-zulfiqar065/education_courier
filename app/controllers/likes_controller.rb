class LikesController < ApplicationController
  before_action :set_likeable
  def create
    @like = current_user.likes.new(like_params)
    respond_to do |format|
      if @like.save
        format.turbo_stream do
          render turbo_stream:
            turbo_stream.replace("comment_#{@likeable.id}_content", partial: 'comments/comment_content',
                                                                    locals: { comment: @likeable, blog: @likeable.blog })
        end
      else
        flash.now[:error] = 'Unable to add like'
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: 'shared/toast') }
      end
    end
  end

  def destroy
    @like = current_user.likes.find_by(likeable_type: @likeable_type, likeable_id: @likeable_id)
    @like.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.replace("comment_#{@likeable.id}_content", partial: 'comments/comment_content',
                                                                  locals: { comment: @likeable, blog: @likeable.blog })
      end
    end
  rescue StandardError
    flash.now[:error] = 'Unable to remove like'
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: 'shared/toast') }
    end
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
end
