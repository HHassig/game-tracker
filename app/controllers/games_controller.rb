class GamesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user
    if @game.save
      redirect_to game_path(@game), notice: 'Game was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @game = Game.find(params[:id])
    @everyone_results = Result.where(game: @game)
    @everyone_average = get_average(@everyone_results)
    @user_results = Result.where(game: @game, user: current_user)
  end

  def follow
    @game = Game.find(params[:id])
    current_user.send_follow_request_to(@game)
    @game.accept_follow_request_of(current_user)
    # raise
    redirect_to game_path(@game)
  end

  def unfollow
    @game = Game.find(params[:id])
    current_user.unfollow_game(@game)
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name, :url)
  end

  def get_average(results)
    sum_score = 0
    results.each do |result|
      sum_score += result.score.to_i
    end
    '%.2f' % (sum_score.to_f / results.length)
  end
end
