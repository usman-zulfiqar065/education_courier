module BlogsConcern
  extend ActiveSupport::Concern

  def handle_failed_blog_creation
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove('error_messages'),
          turbo_stream.prepend('blog_form', partial: 'shared/error_messages', locals: { object: @blog }),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  end

  def handle_failed_blog_update
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.remove('error_messages'),
          turbo_stream.prepend('blog_form', partial: 'shared/error_messages', locals: { object: @blog }),
          turbo_stream.prepend('body_tag', partial: 'shared/toast')
        ]
      end
    end
  end

  def update_user_role
    current_user.update(role: 'blogger') unless current_user.blogger?
  end
end
