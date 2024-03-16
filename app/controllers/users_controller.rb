class UsersController < ApplicationController
  # skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_user, only: %i[show edit update follow unfollow]

  def index
    @games = Game.all
    @user = User.find_by(username: params[:search]) if params[:search].present?
    @following = Follow.where(follower: current_user.id)
    @followers = Follow.where(followee: current_user.id)
    @results = Result.all
  end

  def show
    @following = Follow.where(follower: current_user.id)
    @followers = Follow.where(followee: current_user.id)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      redirect_to user_path(@user), notice: 'Username already taken.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :photo)
  end
end
