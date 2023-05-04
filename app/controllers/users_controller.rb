class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  before_action :set_user, only: %i[show edit update follow unfollow]

  def index
    @games = Game.all
    if params[:search].present?
      # sql_query = <<~SQL
      #   users.username @@ :query
      # SQL
      @search_term = params[:search]
      @user = User.find_by(username: @search_term)
      # @user.find_or_create_by(username: "%#{@search_term}%")
      # raise
    end
    @following = current_user.following
    @followers = current_user.followers
  end

  def show
    @following = current_user.following
    @followers = current_user.followers
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def follow
    current_user.send_follow_request_to(@user)
    @user.accept_follow_request_of(current_user)
    # redirect_to user_path(@user)
    redirect_back(fallback_location: user_path(@user))
  end

  def unfollow
    current_user.unfollow(@user)
    # redirect_to user_path(@user)
    redirect_back(fallback_location: user_path(@user))
  end

  # def accept
  #   current_user.accept_follow_request_of(@user)
  # end

  def decline
  end

  def cancel
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :photo)
  end
end
