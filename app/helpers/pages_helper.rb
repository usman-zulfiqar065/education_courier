module PagesHelper
  def date_format(date)
    if ( DateTime.now.year - date.year ).positive?
      content_tag(:span, date.strftime('%d %b %Y'))
    else
      content_tag(:span, "#{distance_of_time_in_words(date, DateTime.now)} ago", class: "text-muted")
    end
  end

  def get_post_status(post)
    if post.published?
      content_tag(:span, date_format(post.published_at))
    elsif post.scheduled?
      content_tag(:span, "Scheduled for: #{date_format(post.published_at)}", class: 'badge bg-warning ps-2')
    else
      content_tag(:span, 'Draft', class: 'badge bg-danger ps-2')
    end
  end

  def set_post_form_url(post)
    post.persisted? ? "/posts/#{post.id}" : "/users/#{current_user.id}/posts"
  end

  def display_comments_count(count)
    text = count > 1 ? 'comments' : 'comment'
    content_tag(:span, "#{count} #{text}", class: 'h5', id: 'comments_count')
  end

  def display_comment_replies_count(count)
    text = count > 1 ? 'Replies' : 'Reply'
    "#{count } #{text}"
  end

  def comment_form_id(parent)
    parent.present? ? "#{dom_id(parent)}_child_comment" : 'new_comment_form'
  end
end
