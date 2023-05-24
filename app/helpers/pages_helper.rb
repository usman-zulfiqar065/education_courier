module PagesHelper
  def date_format(date, format = 'div')
    if (DateTime.now.year - date.year).positive?
      format == 'div' ? content_tag(:span, date.strftime('%d %b %Y')) : date.strftime('%d %b %Y')
    elsif format == 'div'
      content_tag(:span, "#{distance_of_time_in_words(date, DateTime.now)} ago", class: 'text-muted')
    else
      "#{distance_of_time_in_words(date, DateTime.now)} ago"
    end
  end

  def get_blog_status(blog)
    if blog.published?
      content_tag(:span, date_format(blog.published_at, 'string'))
    elsif blog.scheduled?
      content_tag(:span, "Scheduled for: #{date_format(blog.published_at, 'string')}", class: 'badge bg-warning ps-2')
    else
      content_tag(:span, 'Draft', class: 'badge bg-danger ps-2')
    end
  end

  def blog_form_url(blog)
    blog.persisted? ? "/blogs/#{blog.id}" : "/users/#{current_user.id}/blogs"
  end

  def display_comments_count(count)
    text = count > 1 ? 'comments' : 'comment'
    content_tag(:span, "#{count} #{text}", class: 'h5', id: 'comments_count')
  end

  def display_count(count, klass)
    text = count > 1 ? klass.camelize.pluralize : klass.camelize
    "#{count} #{text}"
  end

  def comment_form_id(parent)
    parent.present? ? "#{dom_id(parent)}_child_comment" : 'new_comment_form'
  end

  def active_tab(controller_name, action_name, tab)
    case tab
    when 'Blogs'
      (controller_name == 'pages' && action_name == 'home') || (controller_name == 'blogs') ? 'active' : ''
    when 'Categories'
      controller_name == 'categories' ? 'active' : ''
    when 'About Us'
      controller_name == 'pages' && action_name == 'about' ? 'active' : ''
    end
  end
end
