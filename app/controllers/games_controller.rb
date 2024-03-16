class GamesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]
  def index
    @games = Game.all
    @my_games = Result.where(user: current_user).map { |result| @my_games << result.game }.uniq
    @other_games = find_other(@my_games)
  end

  def new
    @game = Game.new if current_user.id == 1
  end

  def create
    @game = Game.new(game_params) if current_user.id == 1
    @game.user = current_user
    @game.save ? (redirect_to game_path(@game), notice: 'Game was successfully created.') : (render :new, status: :unprocessable_entity)
  end

  def edit
    @game = Game.find(params[:id]) if current_user.id == 1
  end

  def update
    @game = Game.update!(game_params) if current_user.id == 1
    redirect_to game_path(@game), notice: "Game was successfully updated."
  end

  def show
    @game = Game.find(params[:id])
    @everyone_results = Result.where(game: @game)
    @everyone_average = '%.2f' % @everyone_results.average("score") unless @everyone_results.empty?
    @user_results = Result.where(game: @game, user: current_user)
    @user_average = Average.find_by(game: @game, user: current_user).average if Average.find_by(game: @game, user: current_user)
  end

  def follow
    @game = Game.find(params[:id])
    current_user.send_follow_request_to(@game)
    @game.accept_follow_request_of(current_user)
    redirect_to game_path(@game)
  end

  def unfollow
    @game = Game.find(params[:id])
    current_user.unfollow_game(@game)
    redirect_to game_path(@game)
  end

  private

  def find_other(my_games)
    temp = []
    Game.ids.each { |game| temp << game unless my_games.include? game }
    temp
  end

  def game_params
    params.require(:game).permit(:name, :url)
  end
end
