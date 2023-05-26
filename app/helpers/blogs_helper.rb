module BlogsHelper
  def video_embed_link(original_link)
    original_link.sub('watch?v=', 'embed/')
  end

  def add_start_writing_btn
    if user_signed_in?
      render inline: "<%= link_to 'Start Writing', user_blogs_path(current_user), class: 'btn btn-info' %>"
    else
      render inline: "<button class='btn btn-info' data-bs-toggle='modal'
                              data-bs-target='#exampleModal'>Start Writing</button>"
    end
  end
end
