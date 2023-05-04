module PagesHelper
  def date_format(date)
    date.strftime('%d %b %Y')
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
end
