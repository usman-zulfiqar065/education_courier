module LikesHelper
  def add_like_icon(likeable_id, likeable_type)
    text = likeable_type == 'Comment' ? ' Like' : ''
    style = likeable_type == 'Comment' ? 'bi-hand-thumbs-up' : 'bi-emoji-heart-eyes display-6'
    if user_signed_in? && current_user.liked(likeable_id, likeable_type)
      style = 'bi-hand-thumbs-up-fill text-primary'
      style = 'bi-emoji-heart-eyes-fill text-danger display-6' if likeable_type != 'Comment'
    end
    content_tag(:i, text, class: "bi #{style}")
  end

  def add_like_btn(likeable_id, likeable_type)
    like = Like.find_by(likeable_id:, likeable_type:)
    like_action_path = likes_path(like: { likeable_id:, likeable_type: })
    style = likeable_type == 'Comment' ? 'pt-0 px-0' : 'p-0'
    if user_signed_in? && current_user.liked(likeable_id, likeable_type)
      method = 'delete'
      like_action_path = like_path(like, like: { likeable_id:, likeable_type: })
    end

    if user_signed_in?
      render inline: "<%= button_to add_like_icon('#{likeable_id}', '#{likeable_type}').html_safe,
                          '#{like_action_path}', method: '#{method || 'post'}', class: 'text-dark me-2 btn #{style}',
                          'data-turbo-frame': '_top' %>"
    else
      render inline: "<%= link_to add_like_icon('#{likeable_id}', '#{likeable_type}').html_safe,
                          '#{new_user_registration_path(role: 'member')}',
                          class: 'text-dark me-2 btn #{style}', 'data-turbo-frame': '_top' %>"
    end
  end

  def add_reply_btn(comment)
    reply_action_path = new_user_registration_path(role: 'member')
    data = '_top'
    btn_text = '<i class="bi bi-chat-dots pe-1"></i>Reply'
    if user_signed_in?
      reply_action_path = new_blog_comment_path(comment.blog, parent_id: comment)
      data = "#{dom_id(comment)}_child_comment"
    end
    render inline: "<%= link_to '#{btn_text}'.html_safe, '#{reply_action_path}',
                        'data-turbo-frame': '#{data}', class: 'ps-2 text-dark me-2 py-0 btn' %>"
  end
end
