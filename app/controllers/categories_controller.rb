# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit destroy]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        flash.now[:notice] = 'Category Created Successfully'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace('new_category_form', partial: 'new_category_btn'),
            turbo_stream.prepend('body_tag', partial: 'shared/toast'),
            turbo_stream.append('categories', partial: @category)
          ]
        end
      else
        flash.now[:error] = 'Unable to create category'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend('new_category_form', partial: 'shared/error_messages', locals: { object: @category }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
  end

  def edit; end

  def update
    @category = Category.find(params[:id])
    respond_to do |format|
      if @category.update(category_params)
        flash.now[:notice] = 'Category Updated Successfully'
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("category_#{@category.id}_cart", partial: @category),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      else
        format.turbo_stream do
          flash.now[:error] = 'Unable to update category'
          render turbo_stream: [
            turbo_stream.prepend(helpers.dom_id(@category).to_s, partial: 'shared/error_messages',
                                                                 locals: { object: @category }),
            turbo_stream.prepend('body_tag', partial: 'shared/toast')
          ]
        end
      end
    end
  end

  def destroy
    @category.destroy
    respond_to do |format|
      flash.now[:notice] = 'Category deleted successfully'
      format.turbo_stream do
        render turbo_stream:
      [turbo_stream.prepend('body_tag', partial: 'shared/toast'),
       turbo_stream.remove("category_#{@category.id}_cart")]
      end
    end
  rescue StandardError
    flash.now[:error] = 'Unable to delete category'
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: 'shared/toast') }
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
