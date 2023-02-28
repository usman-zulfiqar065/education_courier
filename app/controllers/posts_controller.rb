class PostsController < ApplicationController
  before_action :get_post, only: %i[ show edit destroy ]

  def index
    @posts = Post.all
  end

  def show; end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to posts_path, notice: 'Post created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to @post, notice: 'Post Updated Successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      redirect_to posts_path, notice: 'Post Deleted Successfully'
    else
      render @post, status: :unprocessable_entity
    end
  end

  private 
  def get_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :summary, :slug, :status)
  end
end
