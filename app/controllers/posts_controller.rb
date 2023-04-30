class PostsController < ApplicationController
  before_action :get_post, only: %i[ show edit destroy update ]

  def index
    @posts = current_user.posts.all
  end

  def show; 
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @categories = Category.all.pluck(:name, :id)
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      redirect_to user_posts_path, notice: 'Post created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post Updated Successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      redirect_to root_path, notice: 'Post Deleted Successfully'
    else
      render @post, status: :unprocessable_entity
    end
  end

  private 
  def get_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :summary, :slug, :status, :read_time, :published_at, :category_id)
  end
end
