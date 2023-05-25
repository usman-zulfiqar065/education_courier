module CommentsCreationHelpers
  extend ActiveSupport::Concern
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
end
