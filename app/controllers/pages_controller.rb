class PagesController < ApplicationController
  def home
    @posts = Post.general
    @featured_post = Post.featured
  end
end
