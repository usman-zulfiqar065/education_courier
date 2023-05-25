module CommentsConcern
  extend ActiveSupport::Concern
  include CommentsCreationHelpers
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
end
