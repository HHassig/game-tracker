class ResultsController < ApplicationController
  def index
    @game = Game.find(params[:game_id])
    @user = current_user
    # @results = Result.where(user: current_user.id)
    @results = Result.where(game: @game.id, user: current_user)
    @average_score = 0
    if @results.length > 0
      @sum_score = 0
      @results.each do |result|
        @sum_score += result.score.to_i
      end
      @average_score = '%.2f' % (@sum_score / @results.length.to_f)
    end
  end

  def new
    @game = Game.find(params[:game_id])
    @result = Result.new
  end

  def create
    @game = Game.find(params[:game_id])
    @result = Result.new(result_params)
    @result.user = current_user.id
    @result.game = @game.id
    if @result.save
      @result.score = @result.get_score(@result.guess)
      @result.edition = @result.get_edition(@result.guess)
      @result.display_score = @result.get_display_score(@result.guess)
      @result.save
      redirect_to game_result_path(@game, @result), notice: 'Result noted.'
    else
      redirect_to root_path
    end
  end

  def show
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
  end

  def edit
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
  end

  def update
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
    if @result.update(result_params)
      redirect_to game_result_path(@game, @result)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @game = Game.find(params[:game_id])
    @result = Result.find(params[:id])
    @result.destroy!
    redirect_to game_results_path(@game), status: :see_other
  end

  private

  def result_params
    params.require(:result).permit(:user, :score, :guess, :game)
  end
end
