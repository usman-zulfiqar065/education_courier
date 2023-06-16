class UserMailer < ApplicationMailer
  def notify_user_about_comment(comment)
    @comment = comment
    @blog_url = "#{ENV['RAILS_APP_URL']}blogs/#{comment.blog.id}"

    mail(to: comment.blog.user.email, subject: 'Education Courier: New comment on your blog')
  end

  def notify_user_about_reply(comment)
    @comment = comment
    @blog_url = "#{ENV['RAILS_APP_URL']}blogs/#{comment.blog.id}"

    mail(to: comment.parent.user.email, subject: 'Education Courier: Reply on your comment')
  end

  def guest_user_feedback(name, email, feedback)
    @name = name
    @email = email
    @feedback = feedback
    @owner = User.owner.first
    mail(to: @owner.email, subject: 'Education Courier: Guest User Feedback')
  end
end
