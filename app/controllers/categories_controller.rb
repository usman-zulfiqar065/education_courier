class CategoriesController < ApplicationController
  before_action :get_category, only: %i[ edit destroy ]

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
        format.turbo_stream { render turbo_stream: [
          turbo_stream.replace('new_category_form', partial: 'new_category_btn'),
          turbo_stream.prepend('body_tag', partial: 'shared/toast'),
          turbo_stream.append('categories', partial: @category)
        ]}
      else
        flash.now[:error] = 'Unable to create category'
        format.turbo_stream { render turbo_stream:  [
          turbo_stream.prepend('new_category_form', partial: 'shared/error_messages', locals: { object: @category }),
          turbo_stream.prepend('body_tag', partial: "shared/toast")
        ]}
      end
    end
  end

  def edit; end

  def update 
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path, notice: 'Category Updated Successfully'
    else
      respond_to do |format|
        flash.now[:error] = 'Unable to update category'
        format.turbo_stream { render turbo_stream:  [
          turbo_stream.prepend("#{helpers.dom_id(@category)}", partial: 'shared/error_messages', locals: { object: @category }),
          turbo_stream.prepend('body_tag', partial: "shared/toast")
        ]}
      end
    end
  end

  def destroy
    begin
      @category.destroy
      respond_to do |format|
        flash.now[:notice] = 'Category deleted successfully'
        format.turbo_stream { render turbo_stream: 
        [ turbo_stream.prepend('body_tag', partial: "shared/toast"),
        turbo_stream.remove(@category)
      ]}
      end
    rescue StandardError => e
      flash.now[:error] = 'Unable to delete category'
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.prepend('body_tag', partial: "shared/toast") }
      end
    end
  end

  private 
  def get_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
