class UsersController < ApplicationController

  def create
    @user = User.find_or_initialize_by(email: params[:email])
    if @user.save
      redirect_to root_path, notice:  'Thankx! for your subscription'
    else
      redirect_to root_path, status: :unprocessable_entity
    end
  end
end
