class PostsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  before_action :set_post, only: %i[show edit destroy update]

  def index
    @posts = current_user.posts.all.in_descending_order
    if params[:query] == 'scheduled_posts'
      @posts = @posts.scheduled
    elsif params[:query] == 'draft_posts'
      @posts = @posts.draft
    end
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @categories = Category.all.pluck(:name, :id)
  end

  def create
    @post = current_user.posts.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to user_posts_path, notice: 'Post created successfully' }
      else
        flash.now[:error] = 'Unable to create post'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("error_messages"),
            turbo_stream.prepend('post_form', partial: 'shared/error_messages', locals: { object: @post }),
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
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post Updated Successfully' }
      else
        flash.now[:error] = 'Unable to update post'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.remove("error_messages"),
            turbo_stream.prepend('post_form', partial: 'shared/error_messages', locals: { object: @post }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
  end

  def destroy
    if @post.destroy
      redirect_to user_posts_path(current_user), notice: 'Post Deleted Successfully'
    else
      render @post, status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  def post_params
    params.require(:post).permit(:title, :content, :summary, :slug, :status, :read_time, :published_at, :category_id)
  end
end
