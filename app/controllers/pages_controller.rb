class PagesController < ApplicationController
  def home
    @posts = Post.all
    @featured_post = Post.last
  end
end
