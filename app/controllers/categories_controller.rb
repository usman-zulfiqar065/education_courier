# frozen_string_literal: true

class CategoriesController < ApplicationController
  load_and_authorize_resource
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_category, only: %i[show]

  def index
    @categories = Category.all
  end

  def show
    @categories = Category.all
    @blogs = Blog.published.includes(:category)
    @blogs = if params[:tag].present?
               @blogs.where('tags like ?', "%#{params[:tag]}%")
             else
               @blogs.where(category_id: params[:id])
             end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
