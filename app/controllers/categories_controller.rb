# frozen_string_literal: true

class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_category, only: %i[show]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.includes(:blogs).where(id: params[:id]).first
    @categories = Category.all
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
