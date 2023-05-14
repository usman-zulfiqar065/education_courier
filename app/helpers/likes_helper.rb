module LikesHelper
  def add_like_icon(likeable_id, likeable_type)
    if current_user.liked(likeable_id, likeable_type)
      content_tag(:i, ' Like', class: 'bi bi-hand-thumbs-up-fill text-primary')
    else
      content_tag(:i, ' Like', class: 'bi bi-hand-thumbs-up')
    end
  end

  def add_like_btn(likeable_id, likeable_type)
    like = Like.find_by(likeable_id:, likeable_type:)
    like_action_path = likes_path(like: { likeable_id:, likeable_type: })
    if current_user.liked(likeable_id, likeable_type)
      method = 'delete'
      like_action_path = like_path(like, like: { likeable_id:, likeable_type: })
    end
    render inline: "<%= button_to add_like_icon('#{likeable_id}', '#{likeable_type}').html_safe, '#{like_action_path}',
                        method: '#{method || 'post'}', class: 'text-dark me-2 btn pt-0 px-0' %>"
  end
end
