class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @posts = general_posts
    @featured_posts = featured_posts.last(6)
    @categories = Category.all.select(:id, :name)
  end

  private 
  def featured_posts
    Post.published.featured.select(:id, :title, :user_id, :published_at, :read_time, :category_id)
        .includes(:user, :category)
  end

  def general_posts
    Post.published.general.select(:id, :title, :user_id, :published_at, :read_time, :summary, :category_id)
        .includes(:user, :category)
  end
end
