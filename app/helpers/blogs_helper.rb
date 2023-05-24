module BlogsHelper
  def video_embed_link(original_link)
    original_link.sub('watch?v=', 'embed/')
  end
end
