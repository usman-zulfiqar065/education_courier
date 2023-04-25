class PagesController < ApplicationController
  def home
    @posts = Post.published.general
    @featured_posts = Post.published.featured
  end
end
