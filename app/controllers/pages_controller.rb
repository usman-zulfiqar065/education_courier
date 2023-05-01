class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @posts = Post.published.general
    @featured_posts = Post.published.featured.last(6)
  end
end
