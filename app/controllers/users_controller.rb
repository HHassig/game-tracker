class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def follow
    @user = User.find(params[:id])
    current_user.send_follow_request_to(@user)
    redirect_to user_path(@user)
  end

  def unfollow
    @user = User.find(params[:id])
    current_user.unfollow(@user)
    redirect_to user_path(@user)
  end

  def accept
    @user = User.find(params[:id])
    current_user.accept_follow_request_of(@user)
  end

  def decline
  end

  def cancel
  end

  private

  def user_params
    params.require(:user).permit(:username, :photo)
  end
end
