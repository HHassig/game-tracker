class FollowsController < ApplicationController
  def index
    raise
  end

  def create
    Follow.create!(follower: params["follower"], followee: params["followee"])
    redirect_back_or_to root_path
  end

  def destroy
    Follow.find(params[:id]).destroy!
    redirect_back_or_to root_path
  end
end
