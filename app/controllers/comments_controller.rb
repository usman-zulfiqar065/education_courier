class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  def index
    @comments = Comment.all
  end

  def show; end

  def new
    @comment = Comment.new
  end

  def edit; end

  def create
    user = find_user
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(user: user, content: comment_params[:content])
    if user.persisted? && @comment.save
      redirect_to @post, notice: 'Thanku for your feed back!'
    else
      @comment.errors.merge!(user.errors)
      render 'posts/show', status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      redirect_to comment_url(@comment), notice: 'Comment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy

    redirect_to comments_url, notice: 'Comment was successfully destroyed.'
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:user_name, :user_email, :content)
    end

    def find_user
      user = User.find_or_initialize_by(email: comment_params[:user_email])
      user.role = 1 unless user.subscriber?
      user.name = comment_params[:user_name]
      user.save
      user
    end
end
