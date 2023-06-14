class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
    @blogs = general_blogs.in_ascending_order
    @featured_blogs = featured_blogs.in_ascending_order.last(6)
    @categories = Category.all.select(:id, :name)
  end

  def about
    @owner = User.owner.first
    @team = User.creator
  end

  def contact; end

  def faqs; end

  private

  def featured_blogs
    Blog.published.featured.select(:id, :title, :user_id, :published_at, :read_time, :category_id)
        .includes(:user, :category)
  end

  def general_blogs
    Blog.published.general.select(:id, :title, :user_id, :published_at, :read_time, :summary, :category_id)
        .includes(:user, :category)
  end
end
