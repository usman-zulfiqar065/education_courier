class BlogsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_blog, only: %i[show edit destroy update]

  def index
    @blogs = current_user.blogs.all.in_descending_order
    if params[:query] == 'scheduled_blogs'
      @blogs = @blogs.scheduled
    elsif params[:query] == 'draft_blogs'
      @blogs = @blogs.draft
    end
  end

  def show; end

  def new
    @blog = Blog.new
    @categories = Category.all.pluck(:name, :id)
  end

  def create
    @blog = current_user.blogs.new(blog_params)
    respond_to do |format|
      if @blog.save
        format.html { redirect_to user_blogs_path, notice: 'Blog created successfully' }
      else
        flash.now[:error] = 'Unable to create blog'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("error_messages"),
            turbo_stream.prepend('blog_form', partial: 'shared/error_messages', locals: { object: @blog }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
  end

  def edit
    @categories = Category.all.pluck(:name, :id)
  end

  def update
    respond_to do |format|
      if @blog.update(blog_params)
        format.html { redirect_to @blog, notice: 'Blog Updated Successfully' }
      else
        flash.now[:error] = 'Unable to update blog'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("error_messages"),
            turbo_stream.prepend('blog_form', partial: 'shared/error_messages', locals: { object: @blog }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
  end

  def destroy
    if @blog.destroy
      redirect_to user_blogs_path(current_user), notice: 'Blog Deleted Successfully'
    else
      render @blog, status: :unprocessable_entity
    end
  end

  private

  def set_blog
    @blog = Blog.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :summary, :slug, :status, :read_time, :published_at, :category_id)
  end
end
